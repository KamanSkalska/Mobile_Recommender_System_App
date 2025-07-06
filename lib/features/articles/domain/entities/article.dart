class Article {
  final String id;
  final String title;
  final String author;
  final String date;
  final String description;
  final List<String> tags;
  final String body;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.description,
    required this.tags,
    required this.body,
  });
}
