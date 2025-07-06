import 'package:article_recommendation_system/core/common/entities/user_tag.dart';

class User {
  final String id;
  final String email;
  final String name;
  List<UserTag>? userTags;

  User(
      {required this.id,
      required this.email,
      required this.name,
      this.userTags});
}
