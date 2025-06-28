# inference.py
# You should work on this file to make it able to load the model and make inference.
# You can add more libraries as you need in the requirements.txt file.

import pandas as pd
import numpy as np
import torch
import keras
import tensorflow as tf
import os

database_url = os.getenv("DATABASE_URL")
shared_dir = os.getenv("SHARED_DIR")