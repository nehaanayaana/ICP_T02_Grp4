import numpy as np

class RecommendationEngine:
    def __init__(self, model, user_encoder, product_encoder, product_reverse_map):
        self.model = model
        self.user_enc = user_encoder
        self.product_enc = product_encoder
        self.product_reverse_map = product_reverse_map

    def recommend_products_for_user(self, user_id, N=10):
        """Recommend products for a given user_id."""
        if user_id not in self.user_enc.classes_:
            return []
        user_idx = np.where(self.user_enc.classes_ == user_id)[0][0]
        recommendations = self.model.recommend(user_idx, N=N)
        results = []
        for product_idx, score in recommendations:
            prod_id = self.product_reverse_map[product_idx]
            results.append({'product_id': prod_id, 'score': float(score)})
        return results

    def recommend_similar_products(self, product_id, N=10):
        """Find similar products to a given product_id."""
        if product_id not in self.product_enc.classes_:
            return []
        product_idx = np.where(self.product_enc.classes_ == product_id)[0][0]
        similar = self.model.similar_items(product_idx, N=N)
        results = []
        for prod_idx, score in similar:
            prod_id = self.product_reverse_map[prod_idx]
            results.append({'product_id': prod_id, 'score': float(score)})
        return results

