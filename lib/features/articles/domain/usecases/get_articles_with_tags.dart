import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/features/articles/domain/entities/article.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/article_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetArticlesPageWithTagsUseCase {
  final ArticleRepository repository;
  GetArticlesPageWithTagsUseCase(this.repository);

  Future<Either<Failure, List<Article>>> call(
      int page, List<String> tags) async {
    return await repository.getArticlesByPageWithTags(page, tags: tags);
  }
}
