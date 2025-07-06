import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/core/usecase/usecase.dart';
import 'package:article_recommendation_system/core/common/entities/user.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final UserTagRepository userTagRepository;
  CurrentUser(this.userTagRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await userTagRepository.currentUser();
  }
}
