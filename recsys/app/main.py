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


from .models import (
    ApiV1EcommerceRecommendationFeedbackPostRequestBody,
    ApiV1EcommerceRecommendationFeedbackPostResponse,
    ApiV1EcommerceRecommendationUserGet200Response,
    ApiV1EcommerceRecommendationUserProductPost200Response,
    ApiV1MessagingChatbotPostRequestBody,
    ApiV1MessagingChatbotPost200Response,
    ErrorResponse,
    PingGet200Response,
    RecommendedProductList,
    RecommendedProductListItem
)

from .inference import (
    recommend_products_for_user,
    recommend_similar_products,
    als_model,
    user_encoder,
    product_encoder,
    product_reverse_map,
    ratings,
    user_items_csr,
)

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

# Load product info CSV; fallback to empty DataFrame if missing
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
df_sale_path = os.path.join(BASE_DIR, "data", "df_sale.csv")
try:
    df_sale = pd.read_csv(df_sale_path)
except FileNotFoundError:
    df_sale = pd.DataFrame()
    print(f"Warning: df_sale.csv not found at {df_sale_path}, product info will be empty")

known_users = set(user_encoder.classes_)
known_products = set(product_encoder.classes_)

# In-memory feedback storage (for demo)
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

@app.post(
    "/api/v1/ecommerce/recommendation/feedback",
    response_model=ApiV1EcommerceRecommendationFeedbackPostResponse,
    responses={"404": {"model": ErrorResponse}},
)
async def feedback(
    body: ApiV1EcommerceRecommendationFeedbackPostRequestBody = Body(...)
):
    user_id_str = str(body.user_id)
    product_id_str = str(body.product_id)

    if user_id_str not in known_users:
        raise HTTPException(status_code=404, detail=f"User '{user_id_str}' not found")

    if product_id_str not in known_products:
        raise HTTPException(status_code=404, detail=f"Product '{product_id_str}' not found")

    feedback_db.append(body.dict())
    return ApiV1EcommerceRecommendationFeedbackPostResponse(message="Feedback submitted successfully")

@app.post(
    "/api/v1/messaging/chatbot",
    response_model=ApiV1MessagingChatbotPost200Response,
    responses={"400": {"model": ErrorResponse}},
)
async def chatbot(
    body: ApiV1MessagingChatbotPostRequestBody = Body(...)
):
    user_id_str = str(body.user_id)
    user_message = body.message

    # TODO: Replace with actual chatbot logic or ML model call
    reply = "Hi, how can I help you today?"
    recommended_products = None  # Optionally add RecommendedProductList here

    return ApiV1MessagingChatbotPost200Response(
        message=reply,
        recommended_products=recommended_products,
    )
    items = [RecommendedProductListItem(**r) for r in sims]
    return ApiV1EcommerceRecommendationUserProductPost200Response(items=RecommendedProductList(root=items))
