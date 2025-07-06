import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/core/usecase/usecase.dart';
import 'package:article_recommendation_system/core/common/entities/user.dart';
import 'package:article_recommendation_system/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
