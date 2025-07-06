import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:article_recommendation_system/core/common/entities/user_tag.dart';
import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/core/common/entities/user.dart';

import 'package:fpdart/fpdart.dart';

abstract interface class UserTagRepository {
  Future<Either<Failure, void>> updateUserTags(UserModel user);

  Future<Either<Failure, List<UserTag>>> downloadUserTags();

  Future<Either<Failure, String?>> getTagIdByType(String tagType);

  Future<Either<Failure, User>> currentUser();

  Future<void> updateUserList(UserModel user, List<String> tagNames);
}
