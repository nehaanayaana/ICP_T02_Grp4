import pickle
from scipy.sparse import csr_matrix

with open("models/user_items_csr.pkl", "rb") as f:
    user_items_csr = pickle.load(f)

print(type(user_items_csr))
print(isinstance(user_items_csr, csr_matrix))
