import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:article_recommendation_system/core/theme/app_pallete.dart';
import 'package:article_recommendation_system/core/theme/widgets_themes.dart';
import 'package:article_recommendation_system/features/articles/data/tags/tags_mapping_to_form.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_four.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_one.dart';
import 'package:article_recommendation_system/init_dependecies.dart';
import 'package:flutter/material.dart';

class FormPageThree extends StatefulWidget {
  final UserModel currentUser;
  const FormPageThree({super.key, required this.currentUser});

  @override
  State<FormPageThree> createState() => _FormPageThreeState();
}

class _FormPageThreeState extends State<FormPageThree> {
  late UserModel currentUser;
  late final UserTagRepository _userTagRepository;

  final List<String> _answerOptions = [
    formTags['tag_education'] ?? 'have a higher education',
    formTags['tag_village_town'] ?? 'live in a village',
    formTags['tag_house_block'] ?? 'live in a flat',
    formTags['tag_pets'] ?? 'have a dog',
    formTags['tag_only_child'] ?? 'have siblings',
    formTags['tag_mood_swings'] ?? 'have mood swings',
    formTags['tag_children'] ?? 'have children',
    formTags['tag_god'] ?? 'believe in god',
    formTags['tag_socializing'] ?? 'like socializing',
    formTags['tag_elections'] ?? 'vote in elections',
    formTags['tag_healthy_eating'] ?? 'eat healthy',
    formTags['tag_prioritising'] ?? 'prioritise workload',
    formTags['tag_notes'] ?? 'write notes',
    formTags['tag_happiness'] ?? 'have happiness in life',
    formTags['tag_finances'] ?? 'save money',
    formTags['tag_parents_advice'] ?? 'like when your parents advise you',
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
              'Do you … ?',
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
                            FormPageFour(currentUser: currentUser)),
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
