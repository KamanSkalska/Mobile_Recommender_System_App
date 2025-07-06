import 'package:article_recommendation_system/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:article_recommendation_system/core/secrets/app_secrets.dart';
import 'package:article_recommendation_system/features/articles/data/datasource/articles_datasource.dart';
import 'package:article_recommendation_system/features/articles/data/datasource/supabase_database_tags.dart';
import 'package:article_recommendation_system/features/articles/data/repositories/article_repository_impl.dart';
import 'package:article_recommendation_system/features/articles/data/repositories/user_with_tags_repository_impl.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/article_repository.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/download_articles.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/download_user_tags.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/get_articles_page.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/get_articles_with_tags.dart';
import 'package:article_recommendation_system/features/articles/domain/usecases/upload_article.dart';
import 'package:article_recommendation_system/features/articles/presentation/bloc/articles_bloc/article_bloc.dart';
import 'package:article_recommendation_system/features/articles/presentation/bloc/user_tags_bloc/user_tag_bloc.dart';
import 'package:article_recommendation_system/features/auth/data/datasources/supabase_database.dart';
import 'package:article_recommendation_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:article_recommendation_system/features/auth/domain/repository/auth_repository.dart';
import 'package:article_recommendation_system/features/auth/domain/usecases/current_user.dart';
import 'package:article_recommendation_system/features/auth/domain/usecases/log_out.dart';
import 'package:article_recommendation_system/features/auth/domain/usecases/user_sign_up.dart';
import 'package:article_recommendation_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/usecases/user_login.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependcies() async {
  _initAuth();
  _initUserTags();
  _initArticle();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
}

void _initAuth() {
  serviceLocator
    ..registerFactory<SupabaseDatabase>(
      () => SupabaseDatabaseImpl(serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator()))
    ..registerFactory(() => UserSignUp((serviceLocator())))
    ..registerFactory(() => UserLogin((serviceLocator())))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => Logout(serviceLocator()))
    ..registerLazySingleton(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
          logout: serviceLocator(),
        ));
}

void _initUserTags() {
  serviceLocator
    ..registerFactory<SupabaseDatabaseTags>(
        () => SupabaseDatabaseTagsImpl(serviceLocator()))
    ..registerFactory<UserTagRepository>(
        () => UserTagRepositoryImpl(serviceLocator()))
    ..registerFactory(() => DownloadUserTags(serviceLocator()))
    ..registerLazySingleton(() => UserTagBloc(
          downloadUserTags: serviceLocator(),
        ));
}

void _initArticle() {
  serviceLocator
    ..registerFactory<ArticleRemoteDataSource>(
      () => ArticleRemoteDataSourceImpl(serviceLocator<http.Client>()),
    )
    ..registerFactory<ArticleRepository>(
      () => ArticleRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(() => UploadArticle(serviceLocator()))
    ..registerFactory(() => GetArticlesUseCase(serviceLocator()))
    ..registerFactory(() => GetArticlesPageUseCase(serviceLocator()))
    ..registerFactory(() => GetArticlesPageWithTagsUseCase(serviceLocator()))
    ..registerLazySingleton(() => ArticleBloc(
          getArticles: serviceLocator(),
          uploadArticle: serviceLocator(),
          getArticlesByPage: serviceLocator(),
          getArticlesPageWithTagsUseCase: serviceLocator(),
        ));
}
