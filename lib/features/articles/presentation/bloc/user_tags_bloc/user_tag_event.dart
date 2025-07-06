part of 'user_tag_bloc.dart';

@immutable
sealed class UserTagEvent {}

final class UserTagUpload extends UserTagEvent {
  final File image;
  final String title;
  final String postedId;
  final String author;
  final String date;
  final String description;
  final List<String> tags;

  UserTagUpload(
      {required this.image,
      required this.title,
      required this.postedId,
      required this.author,
      required this.date,
      required this.description,
      required this.tags});
}

final class FetchDownloadUserTags extends UserTagEvent {}
