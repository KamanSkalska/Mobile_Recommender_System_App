import 'package:article_recommendation_system/core/common/entities/user_tag.dart';

class UserTagModel extends UserTag {
  UserTagModel(
      {required super.id,
      required super.userId,
      required super.tagId,
      super.tagType});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'tagId': tagId,
    };
  }

  factory UserTagModel.fromJSon(Map<String, dynamic> map) {
    return UserTagModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      tagId: map['tag_id'] as String,
    );
  }

  UserTagModel copyWith({
    String? id,
    String? userId,
    String? tagId,
    String? tagType,
  }) {
    return UserTagModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tagId: tagId ?? this.tagId,
      tagType: tagType ?? this.tagType,
    );
  }
}
