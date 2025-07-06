import 'dart:io';

import 'package:article_recommendation_system/features/articles/data/models/article_model.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/download_articles.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/get_articles_page.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/get_articles_with_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:article_recommendation_system/features/articles/domain/entities/article.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/upload_article.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetArticlesUseCase getArticles;
  final UploadArticle uploadArticle;
  final GetArticlesPageUseCase getArticlesByPage;
  final GetArticlesPageWithTagsUseCase getArticlesPageWithTagsUseCase;

  ArticleBloc({
    required this.getArticles,
    required this.uploadArticle,
    required this.getArticlesByPage,
    required this.getArticlesPageWithTagsUseCase,
  }) : super(ArticleInitial()) {
    on<FetchArticles>(_onFetchArticles);
    on<UploadArticleEvent>(_onUploadArticle);
    on<FetchArticlesPage>(_onFetchArticlesPage);
    on<FetchArticlesPageWithTags>(_onFetchArticlesPageWithTags);
    on<LoadBroadenedArticles>(_onLoadBroadenedArticles);
  }

  void _onFetchArticlesPage(
      FetchArticlesPage event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    final res = await getArticlesByPage(event.page);
    res.fold(
      (failure) => emit(ArticleFailure(failure.message)),
      (articles) => emit(ArticleListLoaded(articles)),
    );
  }

  Future<void> _onLoadBroadenedArticles(
      LoadBroadenedArticles event, Emitter<ArticleState> emit) async {
    try {
      emit(ArticleLoading());

      // event.articlesJson is List<Map<String, dynamic>>, so just map directly
      final List<Article> articles = event.articlesJson
          .map<Article>((json) => ArticleModel.fromJson(json))
          .toList();

      emit(ArticleListLoaded(articles));
    } catch (e) {
      emit(ArticleFailure("Failed to load broadened articles: $e"));
    }
  }

  void _onFetchArticlesPageWithTags(
      FetchArticlesPageWithTags event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    final res = await getArticlesPageWithTagsUseCase(event.page, event.tags);
    res.fold(
      (failure) => emit(ArticleFailure(failure.message)),
      (articles) => emit(ArticleListLoaded(articles)),
    );
  }

  void _onFetchArticles(FetchArticles event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    final res = await getArticles();
    res.fold(
      (failure) => emit(ArticleFailure(failure.message)),
      (articles) => emit(ArticleListLoaded(articles)),
    );
  }

  void _onUploadArticle(
      UploadArticleEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());

    final res = await uploadArticle(UploadArticleParams(
      image: event.image,
      title: event.title,
      postedId: event.postedId,
      author: event.author,
      date: event.date,
      description: event.description,
      tags: event.tags,
      body: event.body,
    ));

    res.fold(
      (failure) => emit(ArticleFailure(failure.message)),
      (_) => emit(ArticleUploadSuccess()),
    );
  }
}
