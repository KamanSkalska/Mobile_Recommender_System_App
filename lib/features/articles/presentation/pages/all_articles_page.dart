import 'package:article_recommendation_system/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/features/auth/presentation/pages/user_settings_page.dart';
import 'package:article_recommendation_system/init_dependecies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:article_recommendation_system/features/articles/presentation/bloc/articles_bloc/article_bloc.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/one_article_page.dart';
import 'package:article_recommendation_system/features/articles/data/tags/tags_mapping_to_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  int currentPage = 1;
  final List<String> selectedTagKeys = [];

  void _fetchPage(int page) {
    if (selectedTagKeys.isNotEmpty) {
      context.read<ArticleBloc>().add(
            FetchArticlesPageWithTags(page: page, tags: selectedTagKeys),
          );
    } else {
      context.read<ArticleBloc>().add(FetchArticlesPage(page: page));
    }
  }

  void _nextPage() {
    setState(() => currentPage++);
    _fetchPage(currentPage);
  }

  void _prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      _fetchPage(currentPage);
    }
  }

  void _applyFilter() {
    setState(() => currentPage = 1);
    _fetchPage(currentPage);
  }

  void _broadenKnowledge() async {
    try {
      final userState = context.read<AppUserCubit>().state;
      if (userState is! AppUserLoggedIn) return;

      final user = userState.user;

      // Ensure tags are fetched
      if (user.userTags == null || user.userTags!.isEmpty) {
        final tagRepo = serviceLocator<UserTagRepository>();
        final result = await tagRepo.downloadUserTags();
        result.fold(
          (failure) {
            print("❌ Failed to load user tags: ${failure.message}");
            return;
          },
          (tags) {
            user.userTags = tags;
          },
        );
      }

      final userTags = user.userTags?.map((t) => t.tagType).toList() ?? [];
      if (userTags.isEmpty) return;

      final response = await http.post(
        Uri.parse('http://192.168.1.5:3000/broaden_by_model'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"tags": userTags}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // responseBody is a list of articles directly, not wrapped in a map
        final List articlesJson = List<Map<String, dynamic>>.from(responseBody);

        if (articlesJson.isEmpty) {
          print("⚠️ No articles received from broaden_by_model.");
          return;
        }

        context.read<ArticleBloc>().add(LoadBroadenedArticles(articlesJson));
        print("✅ Loaded ${articlesJson.length} broadened articles.");
      } else {
        print("❌ Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception during broaden: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPage(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.filter_alt),
              tooltip: "Filter by Tags",
              itemBuilder: (context) => formTags.entries.map((entry) {
                final tagLabel = entry.value;
                final tagKey = entry.key;
                final isSelected = selectedTagKeys.contains(tagKey);

                return CheckedPopupMenuItem<String>(
                  value: tagKey,
                  checked: isSelected,
                  child: Text(tagLabel),
                );
              }).toList(),
              onSelected: (tagKey) {
                setState(() {
                  if (selectedTagKeys.contains(tagKey)) {
                    selectedTagKeys.remove(tagKey);
                  } else {
                    selectedTagKeys.add(tagKey);
                  }
                });
              },
            ),
          ),
          TextButton(
            onPressed: _applyFilter,
            child: const Text("Search", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: _broadenKnowledge,
            child: const Text("Broaden Knowledge",
                style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "User Settings",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UserSettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ArticleBloc, ArticleState>(
              builder: (context, state) {
                if (state is ArticleLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ArticleListLoaded) {
                  if (state.articles.isEmpty) {
                    return const Center(child: Text("No articles found."));
                  }
                  return ListView.builder(
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      final article = state.articles[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .transparent, // 🔥 CHANGED: Transparent background
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors
                                      .blueGrey), // Optional: subtle border
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              title: Text(
                                article.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight
                                        .bold), // 🔥 CHANGED: Bigger font
                              ),
                              subtitle: Text(
                                "by ${article.author} - ${article.date}",
                                style: const TextStyle(
                                    fontSize:
                                        12), // 🔥 CHANGED: Slightly larger subtitle
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OneArticlePage(articleJson: article),
                                  ),
                                );
                              },
                            ),
                          ));
                    },
                  );
                } else if (state is ArticleFailure) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text("No articles loaded."));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _prevPage,
                  child: const Text("Previous"),
                ),
                Text("Page $currentPage"),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
