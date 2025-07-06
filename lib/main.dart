import 'package:article_recommendation_system/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:article_recommendation_system/core/theme/theme.dart';
import 'package:article_recommendation_system/features/articles/data/datasource/supabase_database_tags.dart';
import 'package:article_recommendation_system/features/articles/data/repositories/user_with_tags_repository_impl.dart';
import 'package:article_recommendation_system/features/articles/presentation/bloc/articles_bloc/article_bloc.dart';
import 'package:article_recommendation_system/features/articles/presentation/bloc/user_tags_bloc/user_tag_bloc.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/all_articles_page.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_one.dart';
import 'package:article_recommendation_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:article_recommendation_system/features/auth/presentation/pages/login_page.dart';
import 'package:article_recommendation_system/init_dependecies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependcies();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AppUserCubit>(),
    ),
    BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
    BlocProvider(create: (_) => serviceLocator<UserTagBloc>()),
    BlocProvider(create: (_) => serviceLocator<ArticleBloc>()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _tagRepo =
      UserTagRepositoryImpl(serviceLocator<SupabaseDatabaseTags>());

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Article App',
      theme: AppTheme.darkThemeMode,
      home: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          /* if (state is AppUserLoggedIn) {
          final user = state.user;
            if (user.userTags == null || user.userTags!.isEmpty) {
              return const FormPageOne();
            } else {
              return const ArticlesPage();
            }
          }*/
          return const LogInPage();
        },
      ),
    );
  }
}
