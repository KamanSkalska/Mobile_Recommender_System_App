import pandas as pd
import numpy as np

from mongo_connection import  extract_unique_tags, create_article_tag_dataframe, \
    fetch_articles_from_api




def convertCsvToDataframe(dataframe):
    len_of_tags = dataframe.shape[1] - 1
    df_users_ratings = dataframe.iloc[:, 1:1+len_of_tags]
    df_users_ratings = df_users_ratings.fillna(0)
    df_users_ratings = df_users_ratings.map(lambda x: int(x) if isinstance(x, float) else x)
    print("Convritng users df done")
    return df_users_ratings
"""
def createRandomArticlesDataframe(dataframe):
    columns = dataframe.copy().columns
    num_rows = 20
    num_cols = len(columns) - 1
    data = []

    for i in range(num_rows):
        row = np.zeros(num_cols, dtype=int)  # Initialize with all zeros
        ones_indices = np.random.choice(num_cols, size=5, replace=False)  # Choose 5 random positions
        row[ones_indices] = 1  # Set selected positions to 1
        data.append(row)

    df_articles = pd.DataFrame(data, columns=columns[1:])  # Exclude the first column from original columns
    df_articles.insert(0, columns[0], 0)
    return df_articles
"""

def createFinalMatrix(df1,df2):
    user_article_pairs = []
    ratings = []
    for user in df1.index:
        for article in df2.index:
            #write rows from df
            user_vector = df1.loc[user].values
            article_vector = df2.loc[article].values
            print("Write rows doone")
            #change to int
            user_vector = pd.to_numeric(user_vector, errors='coerce')
            article_vector = pd.to_numeric(article_vector, errors='coerce')
            print("change to int done")
            # Replace NaN values with 0 in the vectors
            user_vector = np.nan_to_num(user_vector, nan=0).astype(int)
            article_vector = np.nan_to_num(article_vector, nan=0).astype(int)
            print("User vector: ",user_vector)
            print("Article vector: ",article_vector)

            # Compute similarity (dot product as a simple relevance score)
            relevance_score = np.dot(user_vector, article_vector)
            user_article_pairs.append((user, article))
            ratings.append(relevance_score)
            print("computing similarty done")
    # Convert to DataFrame
    train_data = pd.DataFrame(user_article_pairs, columns=["User", "Article"])
    train_data["Rating"] = ratings
    print(train_data)  # Shows user-article pairs with computed relevance
    print("Relevance score:", relevance_score)
    train_data.to_csv('data/trained_data.csv', index=False)  # index=False prevents saving the index



if __name__=="__main__":
    users_dataframe = pd.read_csv("data/cleaned_tags_file.csv")
    df_users=convertCsvToDataframe(users_dataframe)

    articles = fetch_articles_from_api()
    tag_columns = extract_unique_tags(articles)

    df_articles = create_article_tag_dataframe(articles, tag_columns)
    df_articles.to_csv("data/articles_matrix.csv", index=False)
    print('Article done')
    createFinalMatrix(df_users, df_articles)
    print('Creating final matrix done')












