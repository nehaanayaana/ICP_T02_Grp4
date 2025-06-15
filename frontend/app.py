from flask import Flask, render_template

app = Flask(__name__)

# Sample product data
products = [
    {
        "id": "1",
        "name": "Pupuk SawitPRO 50kg + Abu Janjang 40kg",
        "price": 315934.00,
        "description": "Pupuk SawitPRO adalah pupuk organik yang dapat membantu petani kelapa sawit meningkatkan hasil panen dan kualitas buah. Pupuk ini dilengkapi dengan mikroorganisme yang dikembangkan oleh pakar biologi terkemuka di Indonesia. Mikroorganisme dapat dimanfaatkan untuk membantu penguraian hara dan percepatan dari penyerapan hara pada tanaman. Abu Janjang adalah pupuk organik dengan kandungan K₂O tinggi, sekitar 35%–45%, yang cepat diserap tanaman karena hanya mengandung unsur kalium. Untuk aplikasi, dosis yang dianjurkan adalah 1,5 kg per tanaman. Jika digunakan bersama Pupuk SawitPRO, rekomendasi dosisnya adalah 1 kg Abu Janjang dan 0,5 kg SawitPRO per tanaman.",
        "image": "Pupuk SawitPRO 50kg + Abu Janjang 40kg.png",
        "category": "Fertilizers",
        "rating": 4.5,
        "benefits": [
            "Meningkatkan ketersediaan unsur hara (nitrogen, fosfat, dan kalium)",
            "Membantu perombakan bahan organik (dekomposisi) dan mineralisasi unsur organik",
            "Memicu pertumbuhan tanaman",
            "Melindungi akar dari mikroba patogen",
            "Meningkatkan efisiensi penyerapan dari pupuk lain"
        ],
        "stock": 10,
        "lab_tested": True,
        "dosage": "1 kg Abu Janjang and 0.5 kg SawitPRO per tanaman"
    }
    # Add more products as needed
]

@app.route('/')
def home():
    return render_template('homepage.html')

@app.route('/products')
def product_listing():
    return render_template('productlisting.html', products=products)

if __name__ == '__main__':
    app.run(debug=True)
