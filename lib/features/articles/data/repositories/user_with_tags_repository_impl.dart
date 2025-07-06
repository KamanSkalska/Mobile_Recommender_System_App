import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:article_recommendation_system/core/common/entities/user_tag.dart';
import 'package:article_recommendation_system/core/error/exceptions.dart';
import 'package:article_recommendation_system/core/error/failures.dart';
import 'package:article_recommendation_system/features/articles/data/datasource/supabase_database_tags.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class UserTagRepositoryImpl implements UserTagRepository {
  final SupabaseDatabaseTags tagRemoteDataSource;
  UserTagRepositoryImpl(this.tagRemoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await tagRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('Uzytkownik nie zalogowany'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserTag>>> downloadUserTags() async {
    try {
      final userTags = await tagRemoteDataSource.downloadUserTags();
      return right(userTags);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getTagIdByType(String tagType) async {
    try {
      final tags = await tagRemoteDataSource.getTagIdByType(tagType);
      return right(tags);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, UserTag>> _getUserTags(
    Future<UserTag> Function() fn,
  ) async {
    try {
      final userTag = await fn();
      return right(userTag);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserTags(UserModel currentUser) async {
    try {
      final userTags = currentUser.userTags;
      if (userTags == null || userTags.isEmpty) {
        return left(Failure('No user tags to update'));
      }

      for (final tag in userTags) {
        await tagRemoteDataSource.insertUserTags(
          userId: currentUser.id,
          tagId: tag.tagId,
        );
      }

      return right(null); // ✅ indicates success
    } catch (e) {
      return left(Failure('Failed to update user tags: ${e.toString()}'));
    }
  }

  @override
  Future<void> updateUserList(UserModel user, List<String> tagNames) async {
    user.userTags ??= [];
    for (var tagName in tagNames) {
      if (!user.userTags!.any((userTag) => userTag.tagType == tagName)) {
        final tagId = await tagRemoteDataSource.getTagIdByType(tagName);
        if (tagId != null) {
          user.userTags!
              .add(UserTag(userId: user.id, tagId: tagId, tagType: tagName));
        }
      }
    }
  }
}
