import streamlit as st
import pandas as pd
import numpy as np
import pickle
from scipy.sparse import coo_matrix
from sklearn.metrics import mean_squared_error, precision_score, recall_score, f1_score
from implicit.als import AlternatingLeastSquares
import os

# --- File paths for saved model and encoders ---
MODEL_DIR = "models"
MODEL_FILE = os.path.join(MODEL_DIR, "als_model.pkl")
USER_ENCODER_FILE = os.path.join(MODEL_DIR, "user_encoder.pkl")
PRODUCT_ENCODER_FILE = os.path.join(MODEL_DIR, "product_encoder.pkl")
USER_ITEMS_FILE = os.path.join(MODEL_DIR, "user_items_csr.pkl")

# load saved model and encoders ---
@st.cache_resource
def load_model_and_encoders():
    if not all(os.path.exists(f) for f in [MODEL_FILE, USER_ENCODER_FILE, PRODUCT_ENCODER_FILE, USER_ITEMS_FILE]):
        missing = [f for f in [MODEL_FILE, USER_ENCODER_FILE, PRODUCT_ENCODER_FILE, USER_ITEMS_FILE] if not os.path.exists(f)]
        raise FileNotFoundError(f"Missing model files: {missing}")
    
    with open(MODEL_FILE, "rb") as f:
        model = pickle.load(f)
    with open(USER_ENCODER_FILE, "rb") as f:
        user_enc = pickle.load(f)
    with open(PRODUCT_ENCODER_FILE, "rb") as f:
        product_enc = pickle.load(f)
    with open(USER_ITEMS_FILE, "rb") as f:
        user_items_csr = pickle.load(f)
    
    return model, user_enc, product_enc, user_items_csr


# function to predict ratings from user and product latent factors
def predict_ratings(model, user_indices, product_indices):
    preds = []
    for u, p in zip(user_indices, product_indices):
        if 0 <= u < model.user_factors.shape[0] and 0 <= p < model.item_factors.shape[0]:
            preds.append(model.user_factors[u].dot(model.item_factors[p]))
        else:
            preds.append(0)
    return np.array(preds)


# --- Streamlit UI ---
st.title("🎯 Incremental Learning Prototype Demo: Recommendation System")

st.markdown("""
In **real-world systems**, user preferences and behaviors change constantly. Re-training on the full dataset every time is **too slow and costly**.

This demo shows how we can use **incremental learning** to update a recommendation model using only **new interactions**, without full retraining.

⚠️ **Note:** For this demo, your uploaded CSV should contain columns: `user_id`, `product_id`, and **`quantity`** (or `rating`).  
If your file has `quantity` instead of `rating`, the app will adapt automatically.
""")

try:
    model, user_enc, product_enc, user_items_csr = load_model_and_encoders()
except FileNotFoundError as e:
    st.error(str(e))
    st.stop()

uploaded_file = st.file_uploader("📤 Upload new interaction data (CSV with `user_id`, `product_id`, and `quantity` or `rating`)", type=["csv"])

if uploaded_file:
    df_new = pd.read_csv(uploaded_file)
    
    if 'rating' in df_new.columns:
        interaction_col = 'rating'
    elif 'quantity' in df_new.columns:
        interaction_col = 'quantity'
    else:
        st.error("CSV must contain a 'rating' or 'quantity' column.")
        st.stop()

    required_cols = {'user_id', 'product_id', interaction_col}
    if not required_cols.issubset(df_new.columns):
        st.error(f"CSV must contain columns: {required_cols}")
        st.stop()

    # filter based on only known users and products
    known_users = set(user_enc.classes_)
    known_products = set(product_enc.classes_)
    df_new = df_new[df_new['user_id'].isin(known_users) & df_new['product_id'].isin(known_products)]

    if df_new.empty:
        st.warning("⚠️ No valid interactions left after filtering unknown users/products.")
    else:
        df_new['user_encoded'] = user_enc.transform(df_new['user_id'])
        df_new['product_encoded'] = product_enc.transform(df_new['product_id'])

        # predictions before model update
        preds_before = predict_ratings(model, df_new['user_encoded'], df_new['product_encoded'])
        mse_before = mean_squared_error(df_new[interaction_col], preds_before)
        st.write(f"📉 RMSE on new data **before update**: `{np.sqrt(mse_before):.4f}`")

        # metrics
        y_true = (df_new[interaction_col] >= 1).astype(int)
        y_pred_before = (preds_before >= 1).astype(int)
        precision_b = precision_score(y_true, y_pred_before, zero_division=0)
        recall_b = recall_score(y_true, y_pred_before, zero_division=0)
        f1_b = f1_score(y_true, y_pred_before, zero_division=0)

        st.write(f"**Precision (Before)**: `{precision_b:.4f}`  |  **Recall (Before)**: `{recall_b:.4f}`  |  **F1 Score (Before)**: `{f1_b:.4f}`")

        # update interaction matrix
        new_matrix = coo_matrix(
            (df_new[interaction_col], (df_new['user_encoded'], df_new['product_encoded'])),
            shape=user_items_csr.shape
        )
        updated_matrix = user_items_csr + new_matrix.tocsr()

        # incremental update of the model (re-fit on updated matrix)
        model.fit(updated_matrix.T)

        # Predictions AFTER model update
        preds_after = predict_ratings(model, df_new['user_encoded'], df_new['product_encoded'])
        mse_after = mean_squared_error(df_new[interaction_col], preds_after)
        st.write(f"📈 RMSE on new data **after update**: `{np.sqrt(mse_after):.4f}`")

        y_pred_after = (preds_after >= 1).astype(int)
        precision_a = precision_score(y_true, y_pred_after, zero_division=0)
        recall_a = recall_score(y_true, y_pred_after, zero_division=0)
        f1_a = f1_score(y_true, y_pred_after, zero_division=0)

        st.write(f"**Precision (After)**: `{precision_a:.4f}`  |  **Recall (After)**: `{recall_a:.4f}`  |  **F1 Score (After)**: `{f1_a:.4f}`")

        st.success("✅ Model updated incrementally (in-memory only, not saved).")

        # Display prediction changes
        df_new['pred_before'] = preds_before
        df_new['pred_after'] = preds_after
        df_new['change'] = df_new['pred_after'] - df_new['pred_before']
        st.subheader("🔍 Sample of Predictions Before and After Update")
        st.dataframe(df_new[['user_id', 'product_id', interaction_col, 'pred_before', 'pred_after', 'change']].head(10))

else:
    st.info("📂 Please upload a CSV with columns: `user_id`, `product_id`, and `quantity` or `rating`.")
