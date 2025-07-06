import 'dart:io';

import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/core/usecase/usecase.dart';
import 'package:article_recommendation_system/features/articles/domain/entities/article.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/article_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadArticle implements UseCase<Article, UploadArticleParams> {
  final ArticleRepository articleRepository;
  UploadArticle(this.articleRepository);

  @override
  Future<Either<Failure, Article>> call(UploadArticleParams params) async {
    return await articleRepository.uploadArticle(
        image: params.image,
        title: params.title,
        author: params.author,
        date: params.date,
        description: params.description,
        tags: params.tags,
        body: params.body);
  }
}

class UploadArticleParams {
  final File image;
  final String title;
  final String postedId;
  final String author;
  final String date;
  final String description;
  final List<String> tags;
  final String body;

  UploadArticleParams(
      {required this.image,
      required this.title,
      required this.postedId,
      required this.author,
      required this.date,
      required this.description,
      required this.tags,
      required this.body});
}
