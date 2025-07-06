import 'package:fpdart/fpdart.dart';
import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/features/articles/domain/entities/article.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/article_repository.dart';

class GetArticlesPageUseCase {
  final ArticleRepository repository;

  GetArticlesPageUseCase(this.repository);

  Future<Either<Failure, List<Article>>> call(int page) async {
    return await repository.getArticlesPage(page);
  }
}
