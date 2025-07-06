import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:article_recommendation_system/core/theme/app_pallete.dart';
import 'package:article_recommendation_system/core/theme/widgets_themes.dart';
import 'package:article_recommendation_system/features/articles/data/tags/tags_mapping_to_form.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_one.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_three.dart';
import 'package:article_recommendation_system/init_dependecies.dart';
import 'package:flutter/material.dart';

class FormPageTwo extends StatefulWidget {
  final UserModel currentUser;
  const FormPageTwo({super.key, required this.currentUser});

  @override
  State<FormPageTwo> createState() => _FormPageTwoState();
}

class _FormPageTwoState extends State<FormPageTwo> {
  late UserModel currentUser;
  late final UserTagRepository _userTagRepository;

  final List<String> _anwersOptions = [
    formTags['tag_handedness'] ?? 'left handed',
    formTags['tag_only_child'] ?? 'an only child',
    formTags['tag_hypochondria'] ?? 'hypochondric',
    formTags['tag_loneliness'] ?? 'introvertic (lonely)',
    formTags['tag_assertiveness'] ?? 'assertive',
    formTags['tag_cheating'] ?? 'a cheater',
    formTags['tag_health'] ?? 'heatlthy',
    formTags['tag_charity'] ?? 'part of a charity',
    formTags['tag_achievements'] ?? 'an achiever',
    formTags['tag_workaholism'] ?? 'a workaholic',
    formTags['tag_thinking_ahead'] ?? 'thinking ahead',
    formTags['tag_promises'] ?? 'keeping promises',
    formTags['tag_happiness'] ?? 'happy in live',
    formTags['tag_energy'] ?? 'getting up early',
    formTags['tag_unpopularity'] ?? 'unpopular',
    formTags['tag_decision_making'] ?? 'good in decision making',
  ];

  List<String> selectedTags = [];
  //fina List<String> selectedTags = [];

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
              'Are you.... ?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 70),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _anwersOptions.map((answer) {
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
                            FormPageThree(currentUser: currentUser)),
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
