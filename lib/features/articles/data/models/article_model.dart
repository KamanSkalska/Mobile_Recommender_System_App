import 'package:article_recommendation_system/features/articles/domain/entities/article.dart';

class ArticleModel extends Article {
  ArticleModel({
    required super.id,
    required super.title,
    required super.author,
    required super.date,
    required super.description,
    required super.tags,
    required super.body,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['_id']?.toString() ?? '', // konwersja ObjectId -> String
      title: json['title'] as String? ?? '',
      author: (json['author']?['name'] as String?) ??
          'Unknown', // może nie istnieć w JSON-ie
      date: json['date'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          [],
      body: json['body']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'date': date,
      'description': description,
      'tags': tags,
      'body': body,
    };
  }
}
