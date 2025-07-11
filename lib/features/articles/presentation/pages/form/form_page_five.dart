import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:article_recommendation_system/core/theme/app_pallete.dart';
import 'package:article_recommendation_system/core/theme/widgets_themes.dart';
import 'package:article_recommendation_system/features/articles/data/tags/tags_mapping_to_form.dart';
import 'package:article_recommendation_system/features/articles/domain/repositories/user_tag_repository.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/all_articles_page.dart';
import 'package:article_recommendation_system/features/articles/presentation/pages/form/form_page_one.dart';
import 'package:article_recommendation_system/init_dependecies.dart';
import 'package:flutter/material.dart';

class FormPageFive extends StatefulWidget {
  final UserModel currentUser;
  const FormPageFive({super.key, required this.currentUser});

  @override
  State<FormPageFive> createState() => _FormPageFiveState();
}

class _FormPageFiveState extends State<FormPageFive> {
  late UserModel currentUser;
  late final UserTagRepository _userTagRepository;

  final List<String> _answerOptions = [
    formTags['tag_cars'] ?? 'Cars',
    formTags['tag_exhibitions'] ?? 'Art exhibitions',
    formTags['tag_religion'] ?? 'Religion',
    formTags['tag_countryside'] ?? 'Countryside',
    formTags['tag_outdoors'] ?? 'Outdoors',
    formTags['tag_dancing'] ?? 'Dancing',
    formTags['tag_instruments'] ?? 'Musical instruments',
    formTags['tag_writing'] ?? 'Writing',
    formTags['tag_passive_sport'] ?? 'Passive sport',
    formTags['tag_active_sport'] ?? 'Active sport',
    formTags['tag_gardening'] ?? 'Gardening',
    formTags['tag_celebrities'] ?? 'Celebrities',
    formTags['tag_shopping'] ?? 'Shopping',
    formTags['tag_technology'] ?? 'Science and technology',
    formTags['tag_theatre'] ?? 'Theatre',
    formTags['tag_fun_friends'] ?? 'Fun with friends',
    formTags['tag_adrenaline'] ?? 'Adrenaline sports',
    formTags['tag_pets'] ?? 'Pets',
    formTags['tag_flying'] ?? 'Flying',
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
            const SizedBox(height: 60),
            const Text(
              'What are you interested in?',
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
                  await _userTagRepository.updateUserList(
                      currentUser, selectedTags);
                  final result =
                      await _userTagRepository.updateUserTags(currentUser);

                  result.fold(
                    (failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${failure.message}')),
                      );
                    },
                    (_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ArticlesPage()),
                      );
                    },
                  );
                },
                style: nextButton(context),
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
