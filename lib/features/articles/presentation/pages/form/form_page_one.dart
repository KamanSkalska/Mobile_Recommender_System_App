import 'package:article_recommendation_system/core/theme/widgets_themes.dart';
import 'package:article_recommendation_system/features/articles/data/tags/tags_mapping_to_form.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_two.dart';
import 'package:article_recommendation_system/features/auth/data/datasources/supabase_database.dart';
import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:article_recommendation_system/init_dependecies.dart';
import 'package:flutter/material.dart';

class FormPageOne extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const FormPageOne(),
      );
  const FormPageOne({super.key});

  @override
  _FormPageOneState createState() => _FormPageOneState();
}

class _FormPageOneState extends State<FormPageOne> {
  late UserModel currentUser;
  String? selectedMusic;
  String? selectedFilm;
  String? selectedSpending;
  String? selectedScare;
  late final UserTagRepository _userTagRepository;

  //importing maps with choices
  final List<String> musicOptions = [
    formTags['tag_slow_fast'] ?? 'Slow songs or fast songs',
    formTags['tag_dance'] ?? 'Dance',
    formTags['tag_folk'] ?? 'Folk',
    formTags['tag_country'] ?? 'Country',
    formTags['tag_classical'] ?? 'Classical music',
    formTags['tag_musical'] ?? 'Musical',
    formTags['tag_pop'] ?? 'Pop',
    formTags['tag_rock'] ?? 'Rock',
    formTags['tag_metal'] ?? 'Metal or Hardrock',
    formTags['tag_punk'] ?? 'Punk',
    formTags['tag_hiphop'] ?? 'Hiphop',
    formTags['tag_rap'] ?? 'Rap',
    formTags['tag_ska'] ?? 'Ska',
    formTags['tag_reggae'] ?? 'Reggae',
    formTags['tag_swing'] ?? 'Swing',
    formTags['tag_jazz'] ?? 'Jazz',
    formTags['tag_rocknroll'] ?? 'Rock n roll',
    formTags['tag_alternative'] ?? 'Alternative',
    formTags['tag_latino'] ?? 'Latino',
    formTags['tag_techno'] ?? 'Techno',
    formTags['tag_trance'] ?? 'Trance',
  ];
  final List<String> filmOptions = [
    formTags['tag_opera'] ?? 'Opera',
    formTags['tag_movies'] ?? 'Movies',
    formTags['tag_horror'] ?? 'Horror',
    formTags['tag_thriller'] ?? 'Thriller',
    formTags['tag_comedy'] ?? 'Comedy',
    formTags['tag_romantic'] ?? 'Romantic',
    formTags['tag_scifi'] ?? 'Sci-fi',
    formTags['tag_war'] ?? 'War',
    formTags['tag_fantasy'] ?? 'Fantasy/Fairy tales',
    formTags['tag_animated'] ?? 'Animated',
    formTags['tag_documentary'] ?? 'Documentary',
    formTags['tag_western'] ?? 'Western',
    formTags['tag_action'] ?? 'Action',
  ];

  final List<String> spendingOptions = [
    formTags['tag_brand_clothes'] ?? 'Branded clothing',
    formTags['tag_entertainment'] ?? 'Entertainment spending',
    formTags['tag_looks_spending'] ?? 'Spending on looks',
    formTags['tag_gadgets_spending'] ?? 'Spending on gadgets',
    formTags['tag_health_spending'] ?? 'Spending on healthy eating',
  ];

  final List<String> _scareOptions = [
    formTags['tag_storm'] ?? 'Storm',
    formTags['tag_darkness'] ?? 'Darkness',
    formTags['tag_heights'] ?? 'Heights',
    formTags['tag_spiders'] ?? 'Spiders',
    formTags['tag_snakes'] ?? 'Snakes',
    formTags['tag_rats'] ?? 'Rats',
    formTags['tag_ageing'] ?? 'Ageing',
    formTags['tag_dangerous_dogs'] ?? 'Dangerous dogs',
    formTags['tag_public_speaking_fear'] ?? 'Fear of public speaking',
    formTags['tag_smoking'] ?? 'Smoking',
    formTags['tag_alcohol'] ?? 'Alcohol',
  ];

  final List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    _userTagRepository = serviceLocator<UserTagRepository>();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    final db = serviceLocator<SupabaseDatabase>();
    final user = await db.getCurrentUserData();
    setState(() {
      currentUser = user!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Additional informations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'To better understand your needs and support your growth, please complete the additional fields for article recommendation:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            buildDropdownQuestion(
              question: 'What type of music do you enjoy the most?',
              value: selectedMusic,
              items: musicOptions,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedTags.add(findKey(value));
                  }
                  selectedMusic = value;
                });
              },
            ),
            const SizedBox(height: 20),
            buildDropdownQuestion(
              question: 'What type of films do you enjoy the most?',
              value: selectedFilm,
              items: filmOptions,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedTags.add(findKey(value));
                  }
                  selectedFilm = value;
                });
              },
            ),
            const SizedBox(height: 20),
            buildDropdownQuestion(
              question: 'What do you usually spend the most your money on?',
              value: selectedSpending,
              items: spendingOptions,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedTags.add(findKey(value));
                  }
                  selectedSpending = value;
                });
              },
            ),
            const SizedBox(height: 20),
            buildDropdownQuestion(
              question: 'What are you scared the most?',
              value: selectedScare,
              items: _scareOptions,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedTags.add(findKey(value));
                  }
                  selectedScare = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _userTagRepository.updateUserList(currentUser, selectedTags);
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FormPageTwo(currentUser: currentUser)),
                );
              },
              style: nextButton(context),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownQuestion({
    required String question,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

String findKey(String value) {
  final foundKey = formTags.entries
      .firstWhere((entry) => entry.value == value,
          orElse: () => const MapEntry('', ''))
      .key;
  return foundKey;
}
