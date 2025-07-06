/*
import 'package:article_recommendation_system/core/common/widgets/loader.dart';
import 'package:article_recommendation_system/core/utils/show_snackbar.dart';
import 'package:article_recommendation_system/features/articles/presentation/bloc/article_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ArticlePage(),
      );
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserTagBloc>().add(FetchDownloadUserTags());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Działam. Otrzymane tagu:'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: BlocConsumer<UserTagBloc, UserTagState>(
        listener: (context, state) {
          if (state is ArticleFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is ArticleLoading) {
            print("Loading....");
            return const Loader();
          }
          if (state is ArticleDisplaySuccess) {
            print("We've got it");
            final userTags = state.userTags;

            if (userTags.isEmpty) {
              print("No tags sorry...");
              return const Center(child: Text('No tags found.'));
            }

            return ListView.builder(
              itemCount: userTags.length,
              itemBuilder: (context, index) {
                final tagName = userTags[index].tagType ?? 'Unknown';
                return ListTile(
                  leading: const Icon(Icons.label),
                  title: Text(tagName),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

*/
