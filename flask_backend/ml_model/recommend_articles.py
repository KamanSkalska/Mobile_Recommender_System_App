import numpy as np
import pandas as pd
from tensorflow.keras.models import load_model
import os
from tensorflow.keras.models import load_model

# Get absolute path to the model, relative to this file
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "recommendation_model_with_tags.keras")
TRAIN_DATA_PATH = os.path.join(BASE_DIR, "data", "trained_data.csv")
TAG_DATA_PATH = os.path.join(BASE_DIR, "data", "cleaned_tags_file.csv")
ARTICLES_MATRIX_PATH = os.path.join(BASE_DIR, "data", "articles_matrix.csv")
articles_matrix = pd.read_csv(ARTICLES_MATRIX_PATH)

# Load the model
model = load_model(MODEL_PATH)
print("✅ Model loaded from:", MODEL_PATH)
print("Model loaded successfully!")

# Load training data
train_data = pd.read_csv(TRAIN_DATA_PATH)
tag_data = pd.read_csv(TAG_DATA_PATH)

# Extract unique articles
#unique_articles = train_data["Article"].unique()
unique_articles = train_data["Article"].unique()


# Load tag columns (excluding 'UserID')
tag_columns = tag_data.columns.tolist()[1:]

# Function to create tag vector from explicit tags
def create_tag_vector(tag_list):
    vector = np.zeros(len(tag_columns))
    for tag in tag_list:
        if tag in tag_columns:
            idx = tag_columns.index(tag)
            print("Tag index:",idx)
            vector[idx] = 1
        else:
            print(f"Warning: {tag} not in known tag columns.")
    return vector.reshape(1, -1)

# Function to recommend articles based on tag vector
def recommend_articles_by_tags(tag_list, top_n=5):
    """
    Recommend top N articles based on a tag vector.

    :param tag_list: List of tag strings
    :param top_n: Number of articles to recommend
    :return: DataFrame of top recommended articles and predicted ratings
    """
    tag_vector = create_tag_vector(tag_list)
    tag_matrix = np.repeat(tag_vector, len(unique_articles), axis=0)
    article_array = np.array(unique_articles)

    # Predict ratings
    predicted_ratings = model.predict([tag_matrix, article_array]).flatten()

    # Create DataFrame with recommendations
    recommendations = pd.DataFrame({
        "ArticleID": articles_matrix.iloc[unique_articles, 0].values,
        "Predicted Rating": predicted_ratings
    })

    return recommendations.sort_values(by="Predicted Rating", ascending=False).head(top_n)

# Example usage
#tag_input = ["tag_management", "tag_biology", "tag_dangerous_dogs","tag_movies","tag_dreams","tag_energy"]
#top_recommendations = recommend_articles_by_tags(tag_input)
#print(top_recommendations)
