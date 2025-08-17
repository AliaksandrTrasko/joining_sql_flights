import pandas as pd
import os

csv_path = r"D:/Lern ht code/amazon_project/amazon.csv" # - Путь к исходному файлу
base_folder = os.path.dirname(csv_path) # - Папка для сохранения

amazon = pd.read_csv(csv_path)
#print(amazon.head())

products = amazon[['product_id', 'product_name', 'category', 'rating', 'rating_count']].copy()
products = products.drop_duplicates(subset=['product_id'])
products.to_csv(os.path.join(base_folder, "products.csv"), index=False)

reviews = amazon[['product_id', 'review_id', 'user_id', 'user_name', 'rating', 'rating_count']]
reviews = reviews.drop_duplicates(subset=['review_id'])
reviews.to_csv(os.path.join(base_folder, "reviews.csv"), index=False)

prices = amazon[['product_id', 'discounted_price', 'actual_price', 'discount_percentage']]
prices = prices.drop_duplicates(subset=['product_id'])
prices.to_csv(os.path.join(base_folder, "prices.csv"), index=False)