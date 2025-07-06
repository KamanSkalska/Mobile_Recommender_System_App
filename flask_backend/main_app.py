from flask import Flask, jsonify, request
from flask_cors import CORS
from pymongo import MongoClient
from bson import ObjectId
from ml_model.recommend_articles import recommend_articles_by_tags, create_tag_vector

app = Flask(__name__)
CORS(app)

# MongoDB Atlas URI
MONGO_URI = "mongodb+srv://test123:test123@articles.gevnqde.mongodb.net/Recommender_System?retryWrites=true&w=majority"
articles_per_page=7
try:
    client = MongoClient(MONGO_URI)
    db = client['Recommender_System']
    articles_collection = db['Articles']
    print("✅ MongoDB connected")
except Exception as e:
    print(f"❌ MongoDB error: {e}")

# ✅ All articles for model training (no limit)
@app.route('/articles/all', methods=['GET'])
def get_all_articles():
    try:
        articles = list(articles_collection.find())
        for article in articles:
            article['_id'] = str(article['_id'])
        return jsonify(articles)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ✅ Paginated articles for UI (10 per page)
@app.route('/articles/page', methods=['GET'])
def get_articles_paginated():
    try:
        page = int(request.args.get('page', 1))
        per_page = articles_per_page
        skip = (page - 1) * per_page

        tag_query = request.args.get('tags')
        pipeline = []

        if tag_query:
            selected_tags = tag_query.split(',')

            pipeline += [
                {
                    "$addFields": {
                        "matched_tags": {
                            "$size": {
                                "$setIntersection": ["$tags", selected_tags]
                            }
                        }
                    }
                },
                {
                    "$match": {
                        "matched_tags": {"$gt": 0}
                    }
                },
                {
                    "$sort": {
                        "matched_tags": -1
                    }
                }
            ]

        pipeline += [
            {"$skip": skip},
            {"$limit": per_page}
        ]

        articles = list(articles_collection.aggregate(pipeline))
        for article in articles:
            article['_id'] = str(article['_id'])
        print("Article:", articles)
        return jsonify(articles)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/broaden_by_model", methods=["POST"])
def broaden_by_model():
    data = request.get_json()
    input_tags = data.get("tags", [])
    print("📩 Received tags:", input_tags)

    # Call real model-based recommender
    recommended_articles = recommend_articles_by_tags(input_tags, top_n=7)

    # Get articles from MongoDB based on titles returned by the model
    articles_ids = recommended_articles["ArticleID"].tolist()
    try:
        article_object_ids = [ObjectId(aid) for aid in articles_ids]
    except Exception as e:
        return jsonify({"error": f"Invalid article IDs returned: {e}"}), 400

    db_articles = list(articles_collection.find({"_id": {"$in": article_object_ids}}))
    for article in db_articles:
        article['_id'] = str(article['_id'])
    # Collect tags from recommended articles
    #expanded_tags = set()
    #for article in db_articles:
    #    for tag in article.get("tags", []):
    #        if tag not in input_tags:
    #            expanded_tags.add(tag)

    #print("🔁 Expanded tags:", expanded_tags)
    print("Article:",db_articles)
    return jsonify(db_articles)



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
