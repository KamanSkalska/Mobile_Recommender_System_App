part of 'article_bloc.dart';

@immutable
sealed class ArticleState {}

final class ArticleInitial extends ArticleState {}

final class ArticleLoading extends ArticleState {}

final class ArticleFailure extends ArticleState {
  final String message;
  ArticleFailure(this.message);
}

final class ArticleListLoaded extends ArticleState {
  final List<Article> articles;
  ArticleListLoaded(this.articles);
}

final class ArticleUploadSuccess extends ArticleState {}
