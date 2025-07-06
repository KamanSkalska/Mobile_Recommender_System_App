import 'package:article_recommendation_system/core/error/exceptions.dart';
import 'package:article_recommendation_system/features/articles/data/models/user_tag_model.dart';
import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SupabaseDatabaseTags {
  Session? get currentUserSession;
  Future<void> insertUserTags({required String userId, required String tagId});
  Future<List<UserTagModel>> downloadUserTags();

  Future<String?> getTagIdByType(String tagType);

  Future<UserModel?> getCurrentUserData();
}

class SupabaseDatabaseTagsImpl implements SupabaseDatabaseTags {
  final SupabaseClient supabaseClient;
  SupabaseDatabaseTagsImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJSon(userData.first)
            .copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserTagModel>> downloadUserTags() async {
    try {
      if (currentUserSession != null) {
        final userId = currentUserSession!.user.id;

        final response = await supabaseClient
            .from('user_tags')
            .select('id, user_id, tag_id, tags(id, type)')
            .eq('user_id', userId);

        final List<Map<String, dynamic>> nullList = [];

        final userTags = response.map((tag) {
          final tagData = tag['tags'];
          final tagType = tagData?['type'] as String?;

          if (tagData == null || tagType == null) {
            nullList.add(tag);
          }

          return UserTagModel.fromJSon(tag).copyWith(tagType: tagType);
        }).toList();
        return userTags;
      }

      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String?> getTagIdByType(String tagType) async {
    try {
      final response = await supabaseClient
          .from('tags')
          .select('id')
          .eq('type', tagType)
          .limit(1);
      if (response.isNotEmpty) {
        return response.first['id'] as String;
      } else {
        return null;
      }
    } catch (e) {
      throw ServerException(
          'Failed to get tagId for type $tagType: ${e.toString()}');
    }
  }

  @override
  Future<void> insertUserTags({
    required String userId,
    required String tagId,
  }) async {
    try {
      await supabaseClient.from('user_tags').insert({
        'user_id': userId,
        'tag_id': tagId,
      });
    } catch (e) {
      throw ServerException('Error inserting user tag: ${e.toString()}');
    }
  }
}
