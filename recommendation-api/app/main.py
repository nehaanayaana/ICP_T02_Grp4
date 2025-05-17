from flask import Flask, request, jsonify
import joblib
import numpy as np
import os

from recommendations import RecommendationEngine  # import your class

app = Flask(__name__)

# Base path and model directory
base_path = os.path.dirname(__file__)
model_dir = os.path.join(base_path, '..', 'models')

# Load models and encoders
als_model = joblib.load(os.path.join(model_dir, 'als_model.pkl'))
user_enc = joblib.load(os.path.join(model_dir, 'user_encoder.pkl'))
product_enc = joblib.load(os.path.join(model_dir, 'product_encoder.pkl'))
product_reverse_map = joblib.load(os.path.join(model_dir, 'product_reverse_map.pkl'))

# Instantiate recommendation engine
rec_engine = RecommendationEngine(als_model, user_enc, product_enc, product_reverse_map)

@app.route('/api/v1/ecommerce/recommendations/user/<user_id>', methods=['GET'])
def get_user_recommendations(user_id):
    recs = rec_engine.recommend_products_for_user(user_id)
    return jsonify({'user_id': user_id, 'recommendations': recs})

@app.route('/api/v1/ecommerce/recommendations/products/<product_id>', methods=['GET'])
def get_similar_products(product_id):
    recs = rec_engine.recommend_similar_products(product_id)
    return jsonify({'product_id': product_id, 'recommendations': recs})

@app.route('/api/v1/ecommerce/recommendations/feedback', methods=['POST'])
def submit_feedback():
    feedback = request.json
    # TODO: Save feedback for future training improvements
    return jsonify({'status': 'success', 'message': 'Feedback received', 'data': feedback})

@app.route('/api/v1/messaging/chatbot', methods=['POST'])
def chatbot():
    data = request.json
    user_message = data.get('message', '')
    # TODO: Implement chatbot logic here, for now echo message
    reply = f"Echo: {user_message}"
    return jsonify({'reply': reply, 'products': []})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
