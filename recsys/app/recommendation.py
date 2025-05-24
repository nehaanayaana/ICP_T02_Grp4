import os
import pickle
import logging
from typing import List, Dict, Optional

import pandas as pd

# scikit-learn needed for unpickling LabelEncoders
try:
    import sklearn
except ImportError as e:
    raise ImportError("scikit-learn must be installed to load encoders. Run: pip install scikit-learn") from e

from implicit.als import AlternatingLeastSquares
from scipy.sparse import csr_matrix
from fastapi import HTTPException

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def load_pickle(name: str):
    file_path = os.path.join(BASE_DIR, "models", name)
    if not os.path.isfile(file_path):
        logger.error(f"Pickle file not found: {file_path}")
        raise FileNotFoundError(f"File not found: {file_path}")
    with open(file_path, "rb") as f:
        return pickle.load(f)


# Load models and encoders
try:
    als_model: AlternatingLeastSquares = load_pickle("als_model.pkl")
    user_encoder = load_pickle("user_encoder.pkl")  # LabelEncoder or similar
    product_encoder = load_pickle("product_encoder.pkl")
    product_reverse_map = load_pickle("product_reverse_map.pkl")  # Dict[int, str]
    user_items_csr: csr_matrix = load_pickle("user_items_csr.pkl")  # User-item sparse matrix
except Exception as e:
    logger.error(f"Error loading model files: {e}")
    raise


# Aliases for external imports in FastAPI app
model = als_model
user_map = user_encoder  # user_encoder.classes_ holds known user IDs

try:
    ratings = load_pickle("ratings.pkl")
except FileNotFoundError:
    ratings = None
    logger.warning("ratings.pkl not found, continuing with ratings=None")

try:
    df_sale_path = os.path.join(BASE_DIR, "data", "df_sale.csv")
    df_sale = pd.read_csv(df_sale_path)
except FileNotFoundError:
    df_sale = pd.DataFrame()
    logger.warning(f"df_sale.csv not found at {df_sale_path}, using empty DataFrame")


def recommend_products_for_user(
    user_id: str,
    model: AlternatingLeastSquares,
    user_encoder,
    product_reverse_map: Dict[int, str],
    ratings: Optional[pd.DataFrame],
    df_sale: Optional[pd.DataFrame],
    N: int = 10
) -> List[Dict[str, float]]:
    if user_id not in user_encoder.classes_:
        raise HTTPException(status_code=404, detail=f"User ID '{user_id}' not found")

    user_idx = user_encoder.transform([user_id])[0]
    max_user_idx = model.user_factors.shape[0] - 1

    if user_idx > max_user_idx:
        raise HTTPException(
            status_code=400,
            detail=f"User index {user_idx} is out of range for ALS model with {model.user_factors.shape[0]} users."
        )

    items, scores = model.recommend(user_idx, user_items_csr[user_idx], N)

    results = []
    for item_idx, score in zip(items, scores):
        pid = product_reverse_map.get(item_idx)
        if pid is not None:
            product_info = {}
            if df_sale is not None and not df_sale.empty:
                info = df_sale[df_sale['product_id'] == pid]
                if not info.empty:
                    row = info.iloc[0]
                    product_info = {
                        "product_id": row.get("product_id"),
                        "product_name_en": row.get("product_name_en"),
                        "product_description_en": row.get("product_description_en"),
                        # Add more fields as needed
                    }
            results.append({"product_id": pid, "score": float(score), **product_info})

    return results


def recommend_similar_products(
    product_id: str,
    model: AlternatingLeastSquares,
    product_encoder,
    product_reverse_map: Dict[int, str],
    df_product: Optional[pd.DataFrame] = None,
    N: int = 10
) -> List[Dict[str, float]]:
    """
    Recommend similar products based on ALS model similarity.

    Args:
        product_id (str): The product ID for which to find similar products.
        model (AlternatingLeastSquares): Trained ALS model.
        product_encoder: Encoder used to transform product IDs to internal indices.
        product_reverse_map (Dict[int, str]): Mapping from internal indices back to product IDs.
        df_product (Optional[pd.DataFrame]): DataFrame with product metadata.
        N (int): Number of similar products to return.

    Returns:
        List[Dict[str, float]]: List of similar products with scores and metadata.
    """

    # Check if product_id exists in encoder classes
    if product_id not in product_encoder.classes_:
        raise HTTPException(status_code=404, detail=f"Product ID '{product_id}' not found")

    # Get internal product index
    product_idx = product_encoder.transform([product_id])[0]

    # Get similar items (including the product itself)
    similar_items, scores = model.similar_items(product_idx, N + 1)

    # Exclude the product itself from results
    filtered_items = [(idx, score) for idx, score in zip(similar_items, scores) if idx != product_idx][:N]

    if not filtered_items:
        raise HTTPException(status_code=404, detail=f"No similar products found for product_id '{product_id}'")

    results = []
    for idx, score in filtered_items:
        pid = product_reverse_map.get(idx)
        if pid is None:
            continue  # skip if no mapping found

        product_info = {
            "product_id": pid,
            "score": float(score)
        }

        # If product metadata is provided, add additional info
        if df_product is not None and not df_product.empty:
            product_data = df_product[df_product['product_id'] == pid]
            if not product_data.empty:
                row = product_data.iloc[0]
                product_info.update({
                    "product_name_en": row.get("product_name_en", None),
                    "product_price": row.get("product_price", None),
                    "product_type": row.get("product_type", None),
                    "unit": row.get("unit_of_measurement", None),
                })

        results.append(product_info)

    return results

if __name__ == "__main__":
    print("Sample user IDs:", user_encoder.classes_[:5])
    print("Sample product IDs:", product_encoder.classes_[:5])

    test_user = user_encoder.classes_[0]
    test_product = product_encoder.classes_[0]

    print(f"Recommendations for user {test_user}:")
    print(recommend_products_for_user(test_user, model, user_map, product_reverse_map, ratings, df_sale, N=5))

    print(f"\nSimilar products to {test_product}:")
    print(recommend_similar_products(
        test_product,
        model,
        product_encoder,
        product_reverse_map,
        df_product=None,  # or your actual df if available
        N=5
    ))
