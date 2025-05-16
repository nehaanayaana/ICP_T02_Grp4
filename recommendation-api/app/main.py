from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# Load models and encoders
model = joblib.load('als_model.pkl')
user_enc = joblib.load('user_encoder.pkl')
product_enc = joblib.load('product_encoder.pkl')
product_reverse_map = joblib.load('product_reverse_map.pkl')

# Example function: recommend products for a user using ALS model
def recommend_products_for_user(user_id, N=10):
    if user_id not in user_enc.classes_:
        return []
    user_idx = np.where(user_enc.classes_ == user_id)[0][0]
    recommendations = model.recommend(user_idx, N=N)
    # recommendations is list of (product_idx, score)
    results = []
    for product_idx, score in recommendations:
        prod_id = product_reverse_map[product_idx]
        results.append({'product_id': prod_id, 'score': float(score)})
    return results

# Example function: get similar products
def recommend_similar_products(product_id, N=10):
    if product_id not in product_enc.classes_:
        return []
    product_idx = np.where(product_enc.classes_ == product_id)[0][0]
    similar = model.similar_items(product_idx, N=N)
    results = []
    for prod_idx, score in similar:
        prod_id = product_reverse_map[prod_idx]
        results.append({'product_id': prod_id, 'score': float(score)})
    return results

@app.route('/api/v1/ecommerce/recommendations/user/<user_id>', methods=['GET'])
def get_user_recommendations(user_id):
    recs = recommend_products_for_user(user_id)
    return jsonify({'user_id': user_id, 'recommendations': recs})

@app.route('/api/v1/ecommerce/recommendations/products/<product_id>', methods=['GET'])
def get_similar_products(product_id):
    recs = recommend_similar_products(product_id)
    return jsonify({'product_id': product_id, 'recommendations': recs})

@app.route('/api/v1/ecommerce/recommendations/feedback', methods=['POST'])
def submit_feedback():
    feedback = request.json
    # TODO: Save feedback for future training improvements
    # For now, just acknowledge receipt
    return jsonify({'status': 'success', 'message': 'Feedback received', 'data': feedback})

@app.route('/api/v1/messaging/chatbot', methods=['POST'])
def chatbot():
    data = request.json
    user_message = data.get('message', '')
    # TODO: Implement chatbot logic here, for now echo message
    reply = f"Echo: {user_message}"
    return jsonify({'reply': reply, 'products': []})

if __name__ == '__main__':
    app.run(debug=True)

