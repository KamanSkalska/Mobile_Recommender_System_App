import 'package:article_recommendation_system/core/common/widgets/loader.dart';
import 'package:article_recommendation_system/core/theme/app_pallete.dart';
import 'package:article_recommendation_system/core/utils/show_snackbar.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_one.dart';
import 'package:article_recommendation_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:article_recommendation_system/features/auth/presentation/pages/singup_page.dart';
import 'package:article_recommendation_system/features/auth/presentation/widgets/auth_field.dart';
import 'package:article_recommendation_system/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/all_articles_page.dart';
import 'package:article_recommendation_system/init_dependecies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LogInPage(),
      );

  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final _tagRepo = serviceLocator<UserTagRepository>();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              final user = state.user;

              // ✅ download user tags after login
              final result = await _tagRepo.downloadUserTags();
              result.fold(
                (failure) {
                  // fallback on error
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const FormPageOne()),
                  );
                },
                (tags) {
                  user.userTags = tags;
                  if (tags.isEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const FormPageOne()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ArticlesPage()),
                    );
                  }
                },
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    hintText: "Email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: "Password",
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20),
                  AuthGradientButton(
                    buttonText: 'Sign In',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthLogin(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SignUpPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppPallete.gradient2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
