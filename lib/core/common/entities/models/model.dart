import 'package:article_recommendation_system/core/common/entities/user.dart';
import 'package:article_recommendation_system/core/common/entities/user_tag.dart';

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.email,
      required super.name,
      super.userTags});

  factory UserModel.fromJSon(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    List<UserTag>? userTags,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      userTags: userTags ?? this.userTags,
    );
  }
}
