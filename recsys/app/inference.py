import os
import pickle
import logging
from typing import List, Dict, Optional

import pandas as pd
from implicit.als import AlternatingLeastSquares
from scipy.sparse import csr_matrix

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def load_pickle(filename: str):
    path = os.path.join(BASE_DIR, "models", filename)
    if not os.path.isfile(path):
        logger.error(f"Pickle file not found: {path}")
        raise FileNotFoundError(f"File not found: {path}")
    with open(path, "rb") as f:
        return pickle.load(f)


# Load model & encoders
try:
    als_model = load_pickle("als_model.pkl")
    user_encoder = load_pickle("user_encoder.pkl")
    product_encoder = load_pickle("product_encoder.pkl")
    product_reverse_map = load_pickle("product_reverse_map.pkl")
    user_items_csr = load_pickle("user_items_csr.pkl")
except Exception as e:
    logger.error(f"Error loading model assets: {e}")
    raise

# Load rating and sales data
try:
    ratings = load_pickle("ratings.pkl")
except FileNotFoundError:
    ratings = None
    logger.warning("ratings.pkl not found. Continuing without ratings.")

try:
    df_sale_path = os.path.join(BASE_DIR, "data", "df_sale.csv")
    df_sale = pd.read_csv(df_sale_path)
except FileNotFoundError:
    df_sale = pd.DataFrame()
    logger.warning(f"df_sale.csv not found at {df_sale_path}. Using empty DataFrame.")


def _fallback_products(fallback_list: Optional[pd.DataFrame], N: int) -> List[Dict]:
    """Return fallback product recommendations."""
    if fallback_list is None or fallback_list.empty:
        return []

    fallback = []
    for _, row in fallback_list.head(N).iterrows():
        fallback.append({
            "product_id": str(row.get("product_id")),
            "product_name_en": row.get("product_name_en", "Unknown"),
            "product_type": row.get("product_type", "Unknown"),
            "price": float(row.get("price", 0)) if row.get("price") is not None else 0.0,
            "relevance_score": 0.0,
        })
    return fallback



def recommend_products_for_user(
    user_id: str,
    model,  # AlternatingLeastSquares
    user_encoder,
    product_reverse_map: Dict[int, str],
    user_items_csr,  # CSR matrix of user-item interactions; must be passed or accessible
    ratings: Optional[pd.DataFrame],
    df_sale: Optional[pd.DataFrame],
    fallback_list: Optional[pd.DataFrame] = None,
    N: int = 10
) -> List[Dict]:
    """Recommend top-N products for a given user."""
    
    def _fallback_products(fallback_df, n):
        if fallback_df is None or fallback_df.empty:
            return []
        fallback_recs = []
        for _, row in fallback_df.head(n).iterrows():
            fallback_recs.append({
                "product_id": row.get("product_id", "unknown"),
                "product_name_en": row.get("product_name_en", "Unknown Product"),
                "price": row.get("product_price", None),
                "product_type": row.get("product_type", "Unknown"),
                "relevance_score": None,
                "recommendation_id": str(uuid.uuid4()),
            })
        return fallback_recs
    
    if user_id not in user_encoder.classes_:
        return _fallback_products(fallback_list, N)

    try:
        user_idx = user_encoder.transform([user_id])[0]
        items, scores = model.recommend(user_idx, user_items_csr[user_idx], N)
        
        results = []
        for item_idx, score in zip(items, scores):
            pid = product_reverse_map.get(item_idx)
            if not pid:
                continue

            product_info = {
                "product_id": pid,
                "product_name_en": "Unknown Product",
                "price": None,
                "product_type": "Unknown",
                "relevance_score": float(score),
                "recommendation_id": str(uuid.uuid4()),
            }

            if df_sale is not None and not df_sale.empty:
                row = df_sale[df_sale['product_id'] == pid]
                if not row.empty:
                    first_row = row.iloc[0]
                    product_info["product_name_en"] = first_row.get("product_name_en", product_info["product_name_en"])
                    product_info["price"] = first_row.get("product_price", product_info["price"])
                    product_info["product_type"] = first_row.get("product_type", product_info["product_type"])

            results.append(product_info)

        return results if results else _fallback_products(fallback_list, N)

    except Exception as e:
        logger.error(f"Error in recommend_products_for_user: {e}")
        return _fallback_products(fallback_list, N)


import uuid
from typing import List, Dict, Optional
import pandas as pd
import logging

logger = logging.getLogger(__name__)

def recommend_similar_products(
    product_id: str,
    model,
    product_encoder,
    product_reverse_map: Dict[int, str],
    df_sale: Optional[pd.DataFrame] = None,
    fallback_list: Optional[pd.DataFrame] = None,
    N: int = 10
) -> List[Dict]:
    """Recommend top-N similar products to a given product."""
    if product_id not in product_encoder.classes_:
        return _fallback_products(fallback_list, N)

    try:
        product_idx = product_encoder.transform([product_id])[0]
        similar_items, scores = model.similar_items(product_idx, N + 1)
        filtered_items = [(idx, score) for idx, score in zip(similar_items, scores) if idx != product_idx][:N]

        results = []
        for idx, score in filtered_items:
            pid = product_reverse_map.get(idx)
            if not pid:
                continue

            product_info = {
                "product_id": pid,
                "product_name_en": "Unknown Product",
                "price": None,
                "product_type": "Unknown",
                "relevance_score": float(score),
                "recommendation_id": str(uuid.uuid4())  # Added UUID here
            }

            if df_sale is not None and not df_sale.empty:
                row = df_sale[df_sale['product_id'] == pid].head(1)
                if not row.empty:
                    product_info.update({
                        "product_name_en": row.iloc[0].get("product_name_en", product_info["product_name_en"]),
                        "price": row.iloc[0].get("price", product_info["price"]),
                        "product_type": row.iloc[0].get("product_type", product_info["product_type"]),
                    })

            results.append(product_info)

        return results or _fallback_products(fallback_list, N)

    except Exception as e:
        logger.error(f"Error in recommend_similar_products: {e}")
        return _fallback_products(fallback_list, N)


if __name__ == "__main__":
    print("Sample user IDs:", user_encoder.classes_[:5])
    print("Sample product IDs:", product_encoder.classes_[:5])

    test_user = user_encoder.classes_[0]
    test_product = product_encoder.classes_[0]

    print(f"\nRecommendations for user '{test_user}':")
    for rec in recommend_products_for_user(
        test_user, als_model, user_encoder, product_reverse_map, ratings, df_sale, fallback_list=df_sale, N=5
    ):
        print(rec)

    print(f"\nSimilar products to '{test_product}':")
    for rec in recommend_similar_products(
        test_product, als_model, product_encoder, product_reverse_map, df_sale=df_sale, fallback_list=df_sale, N=5
    ):
        print(rec)
