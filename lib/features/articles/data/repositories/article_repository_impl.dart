import 'dart:io';

import 'package:article_recommendation_system/core/error/exceptions.dart';
import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/features/articles/data/models/article_model.dart';
import 'package:article_recommendation_system/features/articles/domain/entities/article.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/article_repository.dart';
import 'package:article_recommendation_system/features/articles/data/datasource/articles_datasource.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart'; //

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource articleRemoteDataSouce;
  ArticleRepositoryImpl(this.articleRemoteDataSouce);

  @override
  Future<Either<Failure, List<Article>>> getArticlesPage(int page) async {
    try {
      print("Get articles page is used");
      final articles = await articleRemoteDataSouce.getArticlesPage(page);
      return right(articles);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticlesByPageWithTags(int page,
      {List<String> tags = const []}) async {
    try {
      print("Get articles BY page is used");
      final articles = await articleRemoteDataSouce
          .getArticlesByPageWithTags(page, tags: tags);
      return right(articles);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> uploadArticle(
      {required File image,
      required String title,
      required String author,
      required String date,
      required String description,
      required List<String> tags,
      required String body}) async {
    try {
      ArticleModel articleModel = ArticleModel(
          id: Uuid().v1(),
          title: title,
          author: author,
          date: date,
          description: description,
          tags: tags,
          body: body);
      //final imageUrl = await articleRemoteDataSouce.uploadArticleImage(
      //   image: image, article: articleModel);
      final uploadedArticle =
          await articleRemoteDataSouce.uploadArticle(articleModel);
      return right(uploadedArticle);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getAllArticles() async {
    try {
      final articles = await articleRemoteDataSouce.getAllArticles();
      return right(articles);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticlesByTags(
      List<String> tags) async {
    try {
      final articles = await articleRemoteDataSouce.getAllArticles(tags: tags);
      return right(articles);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
