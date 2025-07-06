class UserTag {
  final String? id;
  final String userId;
  final String tagId;
  final String? tagType;

  UserTag({
    this.id,
    required this.userId,
    required this.tagId,
    this.tagType,
  });
}
