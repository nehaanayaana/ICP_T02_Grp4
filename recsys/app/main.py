from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import Dict, Any
import os
import pandas as pd

from .recommendation import (
    recommend_products_for_user,
    recommend_similar_products,  # Correct function name here
    model,
    user_encoder,
    product_encoder,           
    product_reverse_map,
    ratings,
    user_items_csr
)


app = FastAPI(
    title="TokoSawit Product Recommendation API",
    description=(
        "This API provides a recommendation system for TokoSawit. "
        "TokoSawit is an e-commerce platform that is part of the SawitPRO platform, "
        "offering a wide range of plantation equipment and supplies targeted at "
        "Indonesian palm plantation smallholders."
    ),
    terms_of_service="https://www.sawitpro.com/term-and-condition",
    license_info={
        "name": "Proprietary",
        "url": "https://www.sawitpro.com/license",
    },
    version="1.0.0",
    servers=[
        {
            "url": "https://icp-t02-grp4-api.onrender.com",
            "description": "The best project will be deployed at this endpoint.",
        }
    ],
)


# CORS middleware - allow all origins for development, restrict for production
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # TODO: restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load product info CSV; fallback to empty DataFrame if not found
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
df_sale_path = os.path.join(BASE_DIR, "data", "df_sale.csv")  # Adjust path accordingly

try:
    df_sale = pd.read_csv(df_sale_path)
except FileNotFoundError:
    df_sale = pd.DataFrame()
    print(f"Warning: df_sale.csv not found at {df_sale_path}, product info will be empty")

known_users = set(user_encoder.classes_)

@app.get("/", response_model=Dict[str, str])
def root() -> Dict[str, str]:
    return {"message": "Welcome to the E-Commerce Recommendation API"}

# 4.1.1. Get E-Commerce User Recommendation
# This endpoint provides personalized product recommendations for a specific user 
# based on their plantation data, purchase history, and behavioral patterns. 
# It should return a list of at most 10 recommended products sorted by relevance score.
@app.get("/api/v1/ecommerce/recommendations/user/{user_id}", response_model=Dict[str, Any])
def get_user_recommendations(user_id: str, N: int = 5) -> Dict[str, Any]:
    if user_id not in known_users:
        raise HTTPException(status_code=404, detail=f"User '{user_id}' not found")

    recommendations = recommend_products_for_user(
        user_id=user_id,
        model=model,
        user_encoder=user_encoder,
        product_reverse_map=product_reverse_map,
        ratings=ratings,
        df_sale=df_sale,
        N=N
    )

    return {
        "user_id": user_id,
        "recommendations": recommendations,
        "count": len(recommendations),
    }

# 4.1.2. Get E-Commerce Similar Products Recommendations
# This endpoint retrieves products that are similar to a specified product, based on
# various similarity metrics such as product attributes, usage patterns, or complementary 
# functions. It helps users discover alternatives or complementary items to products they're
# already interested in. This will return at most 10 recommended products.
@app.get("/api/v1/ecommerce/recommendations/products/{product_id}", response_model=Dict[str, Any])
def similar_products(product_id: str, N: int = 5):
    # Check if product_id is known
    if product_id not in product_encoder.classes_:
        raise HTTPException(status_code=404, detail=f"Product '{product_id}' not found")

    sims = recommend_similar_products(
        product_id=product_id,
        model=model,
        product_encoder=product_encoder,
        product_reverse_map=product_reverse_map,
        df_product=df_sale,
        N=N
    )
    return {"product_id": product_id, "similar_products": sims}


from pydantic import BaseModel
from datetime import datetime
import pickle

known_products = set(product_encoder.classes_)

class Feedback(BaseModel):
    user_id: str
    product_id: str
    interaction: str
    timestamp: str

feedback_db = []

@app.post("/api/v1/ecommerce/recommendations/feedback")
def submit_feedback(feedback: Feedback):
    # Check user_id existence
    if feedback.user_id not in known_users:
        raise HTTPException(status_code=404, detail=f"User '{feedback.user_id}' not found")

    # Check if product_id is known
    if feedback.product_id not in known_products:
        raise HTTPException(status_code=404, detail=f"Product '{feedback.product_id}' not found")

    # Validate timestamp format
    try:
        datetime.fromisoformat(feedback.timestamp.replace("Z", "+00:00"))
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid timestamp format. Use ISO 8601.")

    feedback_db.append(feedback.dict())
    return {"message": "Feedback submitted successfully", "status": "success"}



if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)
