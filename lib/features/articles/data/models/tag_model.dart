import 'package:article_recommendation_system/core/common/entities/tag.dart';

class TagModel extends Tag {
  TagModel({required super.id, required super.type});

  factory TagModel.fromJSon(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
    );
  }

  TagModel copyWith({
    String? id,
    String? type,
  }) {
    return TagModel(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }
}
