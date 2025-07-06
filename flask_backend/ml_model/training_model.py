import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from tensorflow.keras.layers import Input, Dense, Embedding, Flatten, Concatenate
from tensorflow.keras.models import Model
from tensorflow.keras.optimizers import Adam

# Load training data (ratings)
train_data = pd.read_csv("data/trained_data.csv")  # Must contain columns: User, Article, Rating

# Load user tag vectors
tag_data = pd.read_csv("data/cleaned_tags_file.csv")  # Must contain: UserID, tag_...

# Align and merge tag data with ratings
tag_data = tag_data.rename(columns={"UserID": "User"})
merged_data = train_data.merge(tag_data, on="User", how="inner")

# Extract tag columns and values
tag_columns = merged_data.columns.tolist()[3:]  # Skip User, Article, Rating
merged_data[tag_columns] = merged_data[tag_columns].apply(pd.to_numeric, errors='coerce').fillna(0)
X_tags = merged_data[tag_columns].values.astype(np.float32)
# Extract article IDs
article_ids = merged_data["Article"].values.astype(np.int32)

# Target ratings
y = merged_data["Rating"].values.astype(np.float32)

# Train-test split
X_tags_train, X_tags_test, X_articles_train, X_articles_test, y_train, y_test = train_test_split(
    X_tags, article_ids, y, test_size=0.2, random_state=42
)

# Get number of articles
num_articles = merged_data["Article"].nunique()
article_id_offset = merged_data["Article"].min()  # In case article IDs don't start at 0

# Model inputs
tag_input = Input(shape=(X_tags.shape[1],), name="tag_vector")  # e.g. (7450,)
article_input = Input(shape=(1,), name="article_id")

# Article embedding
article_embedding = Embedding(input_dim=num_articles + article_id_offset + 1, output_dim=50)(article_input)
article_vec = Flatten()(article_embedding)

# Dense layers on tag vector
x = Dense(128, activation="relu")(tag_input)
x = Dense(64, activation="relu")(x)

# Concatenate tag features with article vector
concat = Concatenate()([x, article_vec])

# Output layer
output = Dense(1)(concat)

# Compile the model
model = Model(inputs=[tag_input, article_input], outputs=output)
model.compile(optimizer=Adam(learning_rate=0.001), loss="mse", metrics=["mae"])

# Show summary
model.summary()

# Train the model
history = model.fit(
    [X_tags_train, X_articles_train],
    y_train,
    validation_data=([X_tags_test, X_articles_test], y_test),
    epochs=20,
    batch_size=32
)

# Save the model
model.save("recommendation_model_with_tags.keras")
print("✅ Model trained and saved as recommendation_model_with_tags.keras")
