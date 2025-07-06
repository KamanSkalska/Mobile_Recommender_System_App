part of 'article_bloc.dart';

@immutable
sealed class ArticleEvent {}

final class FetchArticles extends ArticleEvent {}

final class FetchArticlesPage extends ArticleEvent {
  final int page;
  FetchArticlesPage({required this.page});
}

final class FetchArticlesPageWithTags extends ArticleEvent {
  final int page;
  final List<String> tags;

  FetchArticlesPageWithTags({required this.page, required this.tags});
}

final class LoadBroadenedArticles extends ArticleEvent {
  final List<dynamic> articlesJson;

  LoadBroadenedArticles(this.articlesJson);
}

final class UploadArticleEvent extends ArticleEvent {
  final File image;
  final String title;
  final String postedId;
  final String author;
  final String date;
  final String description;
  final List<String> tags;
  final String body;

  UploadArticleEvent({
    required this.image,
    required this.title,
    required this.postedId,
    required this.author,
    required this.date,
    required this.description,
    required this.tags,
    required this.body,
  });
}
