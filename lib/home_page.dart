import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:github_rioi/repository_model.dart';
import 'package:github_rioi/repository_details_page.dart';
import 'package:github_rioi/user_model.dart';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<User> _userFuture;
  late Future<List<GitHubRepository>> _repositoriesFuture;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser();
    _repositoriesFuture = fetchRepositories();
  }

  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse('https://api.github.com/users/${widget.username}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(
        login: data['login'],
        avatarUrl: data['avatar_url'],
        name: data['name'] ?? '',
        bio: data['bio'] ?? '',
        followers: data['followers'],
        following: data['following'],
        publicRepos: data['public_repos'],
      );
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<GitHubRepository>> fetchRepositories() async {
    final response = await http.get(Uri.parse('https://api.github.com/users/${widget.username}/repos'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((repo) {
        return GitHubRepository(
          name: repo['name'],
          description: repo['description'] ?? '',
          stars: repo['stargazers_count'],
          language: repo['language'] ?? '',
          createdAt: repo['created_at'],
          htmlUrl: repo['html_url'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _navigateToRepositoryDetails(GitHubRepository repository) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepositoryDetailsPage(repository: repository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub User'),
        actions: [
          IconButton(
            onPressed: _toggleView,
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data as User;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(user.avatarUrl),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        user.name,
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(user.login),
                      SizedBox(height: 8.0),
                      Text(user.bio),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Followers: ${user.followers}'),
                          SizedBox(width: 16.0),
                          Text('Following: ${user.following}'),
                          SizedBox(width: 16.0),
                          Text('Public Repos: ${user.publicRepos}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: _repositoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final repositories = snapshot.data as List<GitHubRepository>;
                        return _isGridView
                            ? GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: repositories.length,
                                itemBuilder: (context, index) {
                                  final repository = repositories[index];
                                  return GestureDetector(
                                    onTap: () => _navigateToRepositoryDetails(repository),
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            repository.name,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(repository.description),
                                          SizedBox(height: 8.0),
                                          Text('Stars: ${repository.stars}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: repositories.length,
                                itemBuilder: (context, index) {
                                  final repository = repositories[index];
                                  return ListTile(
                                    title: Text(repository.name),
                                    subtitle: Text(repository.description),
                                    trailing: Text('Stars: ${repository.stars}'),
                                    onTap: () => _navigateToRepositoryDetails(repository),
                                  );
                                },
                              );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Failed to load repositories'));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load user'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
     }
}