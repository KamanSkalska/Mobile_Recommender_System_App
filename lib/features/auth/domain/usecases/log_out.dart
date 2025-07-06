import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/core/usecase/usecase.dart';
import 'package:article_recommendation_system/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class Logout implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  Logout(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return authRepository.logout();
  }
}
