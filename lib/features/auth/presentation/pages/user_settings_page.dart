import 'package:article_recommendation_system/features/articles/data/datasource/supabase_database_tags.dart';
import 'package:article_recommendation_system/features/auth/data/datasources/supabase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:article_recommendation_system/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:article_recommendation_system/features/auth/presentation/pages/login_page.dart';
import 'package:article_recommendation_system/features/articles/data/models/user_tag_model.dart';
import 'package:article_recommendation_system/core/common/entities/models/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  late final SupabaseDatabase _supabaseDatabase;
  late final SupabaseDatabaseTags _supabaseDatabaseTags;

  UserModel? _user;
  List<UserTagModel> _userTags = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final supabaseClient =
        Supabase.instance.client; // assuming you use supabase_flutter package
    _supabaseDatabase = SupabaseDatabaseImpl(supabaseClient);
    _supabaseDatabaseTags = SupabaseDatabaseTagsImpl(supabaseClient);

    _fetchUserDataAndTags();
  }

  Future<void> _fetchUserDataAndTags() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userData = await _supabaseDatabase.getCurrentUserData();
      final userTags = await _supabaseDatabaseTags.downloadUserTags();

      setState(() {
        _user = userData;
        _userTags = userTags;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogout());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LogInPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 18), // base style for all text
                          children: [
                            const TextSpan(
                              text: 'Your email address: ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 34, 190, 52)),
                            ),
                            TextSpan(
                              text: _user?.email ?? 'Unknown',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 18), // base style for all text
                          children: [
                            const TextSpan(
                              text: 'Your username: ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 34, 190, 52)),
                            ),
                            TextSpan(
                              text: _user?.name ?? 'Unknown',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('User tags for recommendation:',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 34, 190, 52),
                          )),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _userTags.isEmpty
                            ? const Text('No tags found.')
                            : ListView.builder(
                                itemCount: _userTags.length,
                                itemBuilder: (context, index) {
                                  final tag = _userTags[index];
                                  return ListTile(
                                    title: Text(tag.tagType ?? 'Unknown Tag'),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _logout(context),
                          icon: const Icon(Icons.logout),
                          label: const Text('Log Out'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
