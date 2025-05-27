import pandas as pd
import numpy as np
import os
from datetime import datetime, timedelta

# File paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(SCRIPT_DIR, "data")

SALE_DATA_PATH = os.path.join(DATA_DIR, "df_sale.csv")
SYNTHETIC_SALE_PATH = os.path.join(DATA_DIR, "synthetic_sales.csv")

df_sale = pd.read_csv(SALE_DATA_PATH)

# Inspect columns needed
print("Columns in df_sale:", df_sale.columns.tolist())

# Extract unique categorical values
unique_farm_ids = df_sale['farm_id'].unique()
unique_sale_order_ids = df_sale['sale_order_id'].unique()
unique_product_ids = df_sale['product_id'].unique()
unique_user_ids = df_sale['user_id'].unique()
unique_product_skus = df_sale['product_sku'].unique()
unique_product_types = df_sale['product_type'].unique()
unique_units = df_sale['unit_of_measurement'].unique()

# Map product_id to product info for consistent sampling
product_info = df_sale.drop_duplicates(subset=['product_id']).set_index('product_id')[[
    'product_price', 'product_description_en', 'product_name_en', 'product_sku', 'product_type', 'unit_of_measurement'
]].to_dict(orient='index')

# Date range for time_of_sale (convert ms to datetime)
min_time = pd.to_datetime(df_sale['time_of_sale'], unit='ms').min()
max_time = pd.to_datetime(df_sale['time_of_sale'], unit='ms').max()
total_seconds = int((max_time - min_time).total_seconds())

# Synthetic data generation parameters
num_synthetic = 1000
np.random.seed(42)

synthetic_rows = []

for i in range(num_synthetic):
    farm_id = np.random.choice(unique_farm_ids)
    sale_order_id = np.random.choice(unique_sale_order_ids)
    user_id = np.random.choice(unique_user_ids)
    
    # Pick a product
    product_id = np.random.choice(unique_product_ids)
    info = product_info[product_id]
    
    # Quantity: sample around mean quantity for this product or overall
    mean_qty = df_sale.loc[df_sale['product_id'] == product_id, 'quantity'].mean()
    if np.isnan(mean_qty):
        mean_qty = df_sale['quantity'].mean()
    quantity = max(1, int(np.random.normal(loc=mean_qty, scale=2)))  # At least 1
    
    # Price per unit from product_price (use actual)
    price = info['product_price']
    
    # Calculate total item price
    total_item_price = quantity * price
    
    # Time of sale: random timestamp between min and max
    random_seconds = np.random.randint(0, total_seconds)
    time_of_sale = min_time + timedelta(seconds=random_seconds)
    time_of_sale_ms = int(time_of_sale.timestamp() * 1000)  # ms timestamp
    
    # Build synthetic row
    row = {
        'farm_id': farm_id,
        'sale_order_id': sale_order_id,
        'product_id': product_id,
        'quantity': quantity,
        'price': price,
        'user_id': user_id,
        'total_item_price': total_item_price,
        'time_of_sale': time_of_sale_ms,
        'product_sku': info['product_sku'],
        'product_type': info['product_type'],
        'unit_of_measurement': info['unit_of_measurement'],
        'product_price': price,
        'product_description_en': info['product_description_en'],
        'product_name_en': info['product_name_en']
    }
    
    synthetic_rows.append(row)

# Create DataFrame and save synthetic data
df_synthetic = pd.DataFrame(synthetic_rows)

# Make sure output directory exists
os.makedirs(DATA_DIR, exist_ok=True)

df_synthetic.to_csv(SYNTHETIC_SALE_PATH, index=False)

print(f"Synthetic sales data generated with {len(df_synthetic)} rows and saved to {SYNTHETIC_SALE_PATH}")
