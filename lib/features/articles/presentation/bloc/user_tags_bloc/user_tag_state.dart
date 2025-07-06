part of 'user_tag_bloc.dart';

@immutable
sealed class UserTagState {}

final class UserTagInitial extends UserTagState {}

final class UserTagLoading extends UserTagState {}

final class UserTagFailure extends UserTagState {
  final String error;
  UserTagFailure(this.error);
}

final class UserTagDisplaySuccess extends UserTagState {
  final List<UserTag> userTags;
  UserTagDisplaySuccess(this.userTags);
}

final class UserTagUploadSuccess extends UserTagState {}
