import 'dart:convert';

import 'package:article_recommendation_system/core/error/exceptions.dart';
import 'package:article_recommendation_system/features/articles/data/datasource/dbHelper/constant.dart';
import '../models/article_model.dart';
import 'package:http/http.dart' as http;

abstract interface class ArticleRemoteDataSource {
  Future<ArticleModel> uploadArticle(ArticleModel article);
  Future<List<ArticleModel>> getAllArticles({List<String>? tags});
  Future<List<ArticleModel>> getArticlesPage(int page);
  Future<List<ArticleModel>> getArticlesByPageWithTags(int page,
      {List<String>? tags});
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final http.Client client;
  ArticleRemoteDataSourceImpl(this.client);

  @override
  Future<List<ArticleModel>> getAllArticles({List<String>? tags}) async {
    try {
      String url = '$BASE_URL/all';
      if (tags != null && tags.isNotEmpty) {
        final tagParam = tags.join(',');
        url = '$BASE_URL?tags=$tagParam';
      }

      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => ArticleModel.fromJson(e)).toList();
      } else {
        throw const ServerException("Failed to fetch articles");
      }
    } catch (e) {
      throw ServerException("HTTP error: ${e.toString()}");
    }
  }

  @override
  Future<ArticleModel> uploadArticle(ArticleModel article) {
    // TODO: implement uploadArticle
    throw UnimplementedError();
  }

  @override
  Future<List<ArticleModel>> getArticlesPage(int page) async {
    try {
      final url = Uri.parse('$BASE_URL/articles/page?page=$page');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => ArticleModel.fromJson(e)).toList();
      } else {
        throw const ServerException("Failed to fetch paginated articles");
      }
    } catch (e) {
      throw ServerException("HTTP error: ${e.toString()}");
    }
  }

  @override
  Future<List<ArticleModel>> getArticlesByPageWithTags(int page,
      {List<String>? tags}) async {
    try {
      String url = "$BASE_URL/articles/page?page=$page";
      if (tags != null && tags.isNotEmpty) {
        final tagParam = tags.join(',');
        url += "&tags=$tagParam";
      }

      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => ArticleModel.fromJson(e)).toList();
      } else {
        throw const ServerException("Failed to fetch paginated articles");
      }
    } catch (e) {
      throw ServerException("HTTP error: ${e.toString()}");
    }
  }
}
