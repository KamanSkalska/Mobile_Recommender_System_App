import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:article_recommendation_system/core/theme/app_pallete.dart';
import 'package:article_recommendation_system/core/theme/widgets_themes.dart';
import 'package:article_recommendation_system/features/articles/data/tags/tags_mapping_to_form.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_five.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_one.dart';
import 'package:article_recommendation_system/init_dependecies.dart';
import 'package:flutter/material.dart';

class FormPageFour extends StatefulWidget {
  final UserModel currentUser;
  const FormPageFour({super.key, required this.currentUser});

  @override
  State<FormPageFour> createState() => _FormPageFourState();
}

class _FormPageFourState extends State<FormPageFour> {
  late UserModel currentUser;
  late final UserTagRepository _userTagRepository;

  final List<String> _answerOptions = [
    formTags['tag_history'] ?? 'History',
    formTags['tag_psychology'] ?? 'Psychology',
    formTags['tag_politics'] ?? 'Politics',
    formTags['tag_math'] ?? 'Mathematics',
    formTags['tag_technology'] ?? 'Computers',
    formTags['tag_economy'] ?? 'Economy',
    formTags['tag_management'] ?? 'Management',
    formTags['tag_biology'] ?? 'Biology',
    formTags['tag_chemistry'] ?? 'Chemistry',
    formTags['tag_reading'] ?? 'Reading',
    formTags['tag_geography'] ?? 'Geography',
    formTags['tag_languages'] ?? 'Foreign languages',
    formTags['tag_medicine'] ?? 'Medicine',
    formTags['tag_law'] ?? 'Law',
  ];

  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    _userTagRepository = serviceLocator<UserTagRepository>();
    currentUser = widget.currentUser;
  }

  void toggleSelection(String answer) {
    setState(() {
      if (selectedTags.contains(answer)) {
        selectedTags.remove(answer);
      } else {
        selectedTags.add(findKey(answer));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Additional informations')),
      backgroundColor: AppPallete.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center items vertically
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'What industry do you work/study in?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 70),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _answerOptions.map((answer) {
                final isSelected = selectedTags.contains(findKey(answer));
                return ElevatedButton(
                  onPressed: () => toggleSelection(answer),
                  style: answerButtonStyle(isSelected: isSelected),
                  child: Text(answer),
                );
              }).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _userTagRepository.updateUserList(
                        currentUser, selectedTags);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FormPageFive(currentUser: currentUser)),
                  );
                },
                style: nextButton(context),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
