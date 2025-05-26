
from fastapi import FastAPI, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware
from typing import Union
from uuid import UUID
import os
import pandas as pd
from typing import List
import logging

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

# importing models
from app.models import (
    ApiV1EcommerceRecommendationFeedbackPostRequestBody,
    ApiV1EcommerceRecommendationFeedbackPostResponse,
    ApiV1EcommerceRecommendationUserProductPost200Response,  
    ApiV1EcommerceRecommendationUserGet200Response,
    ApiV1MessagingChatbotPostRequestBody,
    ApiV1MessagingChatbotPost200Response,
    ErrorResponse,
    PingGet200Response,
    RecommendedProductList,
    RecommendedProductListItem
)

# importing inference logic
from app.inference import (
    recommend_products_for_user,
    recommend_similar_products,
    als_model,
    user_encoder,
    product_encoder,
    product_reverse_map,
    ratings,
    user_items_csr,
)

# title of fast api project
app = FastAPI(
    title='TokoSawit ProductRecommendation API',
    description=(
        'This API provides recommendation system for TokoSawit. TokoSawit is an e-commerce platform, '
        'part of SawitPRO targeting Indonesian palm plantation smallholders.'
    ),
    version='1.0.0',
)

# CORS Middleware - allow all origins for now (restrict in prod)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# load product info csv and have a fallback to empty df if missing
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
df_sale_path = os.path.join(BASE_DIR, "data", "df_sale.csv")
try:
    df_sale = pd.read_csv(df_sale_path)
except FileNotFoundError:
    df_sale = pd.DataFrame()
    print(f"Warning: df_sale.csv not found at {df_sale_path}, product info will be empty")

known_users = set(user_encoder.classes_)
known_products = set(product_encoder.classes_)

feedback_db = []

@app.get('/ping', response_model=PingGet200Response)
def ping() -> PingGet200Response:
    return PingGet200Response(message="pong")

@app.get("/")
def root():
    return {"message": "Welcome to the TokoSawit ProductRecommendation API"}




from fastapi import APIRouter, HTTPException
from uuid import UUID
from typing import List
import uuid


# GET /api/v1/ecommerce/recommendations/user/{user_id}
@app.get(
    '/api/v1/ecommerce/recommendation/user/{user_id}',
    response_model=ApiV1EcommerceRecommendationUserGet200Response,
    responses={404: {"model": ErrorResponse}},
)
def recommend_for_user(user_id: UUID, N: int = 10):
    user_id_str = str(user_id)
    
    if user_id_str not in known_users:
        raise HTTPException(status_code=404, detail=f"User '{user_id_str}' not found")

    recs = recommend_products_for_user(
        user_id=user_id_str,
        model=als_model,
        user_encoder=user_encoder,
        product_reverse_map=product_reverse_map,
        ratings=ratings,
        df_sale=df_sale,
        user_items_csr=user_items_csr,
        N=N,
    )

    items = []
    for rec in recs:
        try:
            pid = rec.get("product_id")
            score = rec.get("relevance_score", 0.0)

            # Lookup product details by product_id only
            if df_sale.empty:
                product_name_en = "Unknown Product"
                price = None
                product_type = "Unknown"
            else:
                product_row = df_sale.loc[df_sale['product_id'] == pid]
                if product_row.empty:
                    product_name_en = "Unknown Product"
                    price = None
                    product_type = "Unknown"
                else:
                    product_name_en = product_row.iloc[0].get("product_name_en", "Unknown Product")
                    price = product_row.iloc[0].get("price", None)
                    product_type = product_row.iloc[0].get("product_type", "Unknown")

            product_info = {
                "product_id": pid,
                "product_name_en": product_name_en,
                "price": price,
                "product_type": product_type,
                "relevance_score": float(score),
                "recommendation_id": str(uuid.uuid4()),
            }
            item = RecommendedProductListItem(**product_info)
            items.append(item)
        except Exception as e:
            logger.error(f"Failed to parse recommended product item: {e}")
            continue

    return ApiV1EcommerceRecommendationUserGet200Response(
        items=RecommendedProductList(root=items)
    )


# GET /api/v1/ecommerce/recommendations/products/{product_id}
@app.get(
    '/api/v1/ecommerce/recommendation/product/{product_id}',
    response_model=ApiV1EcommerceRecommendationUserProductPost200Response,
    responses={'404': {'model': ErrorResponse}},
)
def recommend_similar_products_api(product_id: UUID, N: int = 10):
    product_id_str = str(product_id)
    if product_id_str not in known_products:
        raise HTTPException(status_code=404, detail=f"Product '{product_id_str}' not found")

    sims = recommend_similar_products(
        product_id=product_id_str,
        model=als_model,
        product_encoder=product_encoder,
        product_reverse_map=product_reverse_map,
        df_sale=df_sale,
        N=N,
    )

    items = [RecommendedProductListItem(**s) for s in sims]
    return ApiV1EcommerceRecommendationUserProductPost200Response(items=RecommendedProductList(root=items))


# POST /api/v1/ecommerce/recommendations/feedback
import requests
from fastapi import FastAPI, Body, HTTPException
feedback_db = []

GA_MEASUREMENT_ID = "G-X0R8L7MWCQ"  # Replace with your actual GA4 Measurement ID
GA_API_SECRET = "ZoVOyQEaTaGo803pojOajQ"   # Replace with your actual GA4 API Secret
GA_ENDPOINT = f"https://www.google-analytics.com/mp/collect?measurement_id={GA_MEASUREMENT_ID}&api_secret={GA_API_SECRET}"


feedback_db = []

def send_feedback_to_ga(feedback: ApiV1EcommerceRecommendationFeedbackPostRequestBody):
    event_name = "recommendation_feedback"
    event_params = {
        "user_id": str(feedback.user_id),
        "product_id": str(feedback.product_id),
        "recommendation_id": str(feedback.recommendation_id) if feedback.recommendation_id else "none",
        "action": feedback.action.value,
    }
    payload = {
        "client_id": str(feedback.user_id),  # or some unique client id
        "events": [
            {
                "name": event_name,
                "params": event_params,
            }
        ],
    }

    response = requests.post(GA_ENDPOINT, json=payload)
    response.raise_for_status()
    return response

@app.post(
    "/api/v1/ecommerce/recommendation/feedback",
    response_model=ApiV1EcommerceRecommendationFeedbackPostResponse,
)
def feedback(
    body: ApiV1EcommerceRecommendationFeedbackPostRequestBody = Body(...),
):
    if str(body.user_id) not in known_users:
        raise HTTPException(status_code=404, detail=f"User '{body.user_id}' not found")

    if str(body.product_id) not in known_products:
        raise HTTPException(status_code=404, detail=f"Product '{body.product_id}' not found")

    feedback_db.append(body.dict())

    try:
        send_feedback_to_ga(body)
    except requests.HTTPError as e:
        print(f"Failed to send feedback to GA4: {e}")

    return ApiV1EcommerceRecommendationFeedbackPostResponse(
        message="Feedback given successfully"
    )


# POST /api/v1/messaging/chatbot
from huggingface_hub import InferenceClient
import os

from huggingface_hub import InferenceClient

client = InferenceClient(api_key="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")


def get_chatbot_response(prompt: str) -> str:
    response = client.chat_completion(
        model="meta-llama/Llama-3.2-3B-Instruct",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3,
        max_tokens=300,
        top_p=0.9
    )
    return response.choices[0].message["content"]

def get_fake_product_recommendations(category: str):
    fertilizer_products = [
        {"product_id": "c5e57af4-0df9-4e2b-87e4-9024b8e6cf53", "product_name_en": "DMA 6 825 SL 400ml", "product_type": "GOODS", "price": 89000.0},
        {"product_id": "8152e395-0f7a-4dda-8df9-6655a726c4e1", "product_name_en": "Sawitpro fertilizer 20kg + ash janjang 40kg", "product_type": "GOODS", "price": 223500.0},
        {"product_id": "2485b082-5258-44c1-b6aa-983387d540a7", "product_name_en": "Batara 135 SL - 1 liter", "product_type": "GOODS", "price": 42300.0},
    ]
    
    pesticide_products = [
        {"product_id": "8fcfd7a8-5980-4e7e-b463-6d30823caac4", "product_name_en": "Meroke Ss - Ammophos 50kg", "product_type": "GOODS", "price": 488750.0},
        {"product_id": "8df8c2e5-5ad8-490f-83b2-57fa0c961f84", "product_name_en": "Meroke Korn Kali B (KKB) 50kg", "product_type": "GOODS", "price": 414825.0},
    ]

    # You can add more categories similarly
    if category == "fertilizer":
        return fertilizer_products
    elif category == "pesticide":
        return pesticide_products
    else:
        return []  # empty list if no category matched
    
import difflib

def correct_keyword(input_text, keywords, cutoff=0.7):
    # input_text: user message (lowercase)
    # keywords: list of keywords to check
    # cutoff: similarity threshold (0 to 1)
    words = input_text.split()
    for word in words:
        close_matches = difflib.get_close_matches(word, keywords, n=1, cutoff=cutoff)
        if close_matches:
            return close_matches[0]  # return the best matched keyword
    return None


@app.post(
    "/api/v1/messaging/chatbot",
    response_model=ApiV1MessagingChatbotPost200Response,
    responses={"400": {"model": ErrorResponse}, "404": {"model": ErrorResponse}},
)
async def chatbot(
    body: ApiV1MessagingChatbotPostRequestBody = Body(...)
):
    if str(body.user_id) not in known_users:
        raise HTTPException(status_code=404, detail=f"User '{body.user_id}' not found")

    user_message = body.message.strip()
    if not user_message:
        raise HTTPException(status_code=400, detail="Message is required.")

    lowered = user_message.lower()
    keywords = ["fertilizer", "pesticide"]

    corrected = correct_keyword(lowered, keywords)
    
    if corrected == "fertilizer":
        recommended_products = get_fake_product_recommendations("fertilizer")
        return ApiV1MessagingChatbotPost200Response(
            message="Here are some fertilizer products I recommend:",
            recommended_products=recommended_products
        )
    elif corrected == "pesticide":
        recommended_products = get_fake_product_recommendations("pesticide")
        return ApiV1MessagingChatbotPost200Response(
            message="Here are some pesticide products I recommend:",
            recommended_products=recommended_products
        )

    chatbot_reply = get_chatbot_response(user_message)
    return ApiV1MessagingChatbotPost200Response(
        message=chatbot_reply,
        recommended_products=None
    )
