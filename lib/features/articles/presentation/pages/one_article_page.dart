import 'package:flutter/material.dart';
import 'package:article_recommendation_system/features/articles/domain/entities/article.dart';

class OneArticlePage extends StatelessWidget {
  final Article articleJson;

  const OneArticlePage({super.key, required this.articleJson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(articleJson.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              articleJson.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'by ${articleJson.author} • ${articleJson.date}',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(
              articleJson.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (articleJson.tags.isNotEmpty) ...[
              const Text(
                'Tags:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: articleJson.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            if ((articleJson as dynamic).body != null) ...[
              const Text(
                'Full Article:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text((articleJson as dynamic).body ??
                  ''), // 👈 jeśli pole `body` istnieje
            ],
          ],
        ),
      ),
    );
  }
}
