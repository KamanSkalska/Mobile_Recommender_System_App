import 'package:article_recommendation_system/core/common/entities/user_tag.dart';
import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/core/usecase/usecase.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:fpdart/fpdart.dart';

class DownloadUserTags implements UseCase<List<UserTag>, NoParams> {
  final UserTagRepository userTagRepository;
  DownloadUserTags(this.userTagRepository);

  @override
  Future<Either<Failure, List<UserTag>>> call(NoParams params) async {
    return await userTagRepository.downloadUserTags();
  }
}
