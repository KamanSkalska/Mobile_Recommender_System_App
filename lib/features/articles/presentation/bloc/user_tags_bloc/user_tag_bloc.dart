import 'dart:io';

import 'package:article_recommendation_system/core/common/entities/user_tag.dart';
import 'package:article_recommendation_system/core/usecase/usecase.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/download_user_tags.dart';
//import 'package:article_recommendation_system/features/articles/domain/usecases/upload_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_tag_event.dart';
part 'user_tag_state.dart';

class UserTagBloc extends Bloc<UserTagEvent, UserTagState> {
  //final UploadArticle _uploadArticle;
  final DownloadUserTags _downloadUserTags;

  UserTagBloc({
    //required UploadArticle uploadArticle,
    required DownloadUserTags downloadUserTags,
  })  :
        //_uploadArticle = uploadArticle,
        _downloadUserTags = downloadUserTags,
        super(UserTagInitial()) {
    on<UserTagEvent>((event, emit) => emit(UserTagLoading()));
    // on<ArticleUpload>(_onArticleUpload);
    on<FetchDownloadUserTags>(_onFetchDownloadUserTags);
  }

  /* void _onArticleUpload(ArticleUpload event, Emitter<UserTagState> emit) async {
    final res = await _uploadArticle(UploadArticleParams(
        image: event.image,
        title: event.title,
        postedId: event.postedId,
        author: event.author,
        date: event.date,
        description: event.description,
        tags: event.tags));
    res.fold((l) => emit(ArticleFailure(l.message)),
        (r) => emit(ArticleUploadSuccess()));
  }
*/

  void _onFetchDownloadUserTags(
    FetchDownloadUserTags event,
    Emitter<UserTagState> emit,
  ) async {
    emit(UserTagLoading());
    final res = await _downloadUserTags(NoParams());

    res.fold(
      (l) => emit(UserTagFailure(l.message)),
      (r) => emit(UserTagDisplaySuccess(r)),
    );
  }
}
