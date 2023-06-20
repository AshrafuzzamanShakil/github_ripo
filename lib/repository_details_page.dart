import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:github_rioi/repository_model.dart';
class RepositoryDetailsPage extends StatelessWidget {
  final GitHubRepository repository;

  RepositoryDetailsPage({required this.repository});

  void _launchUrl() async {
    // ignore: deprecated_member_use
    if (await canLaunch(repository.htmlUrl)) {
      // ignore: deprecated_member_use
      await launch(repository.htmlUrl);
    } else {
      throw 'Could not launch ${repository.htmlUrl}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repository Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              repository.name,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(repository.description),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.star, size: 16.0),
                SizedBox(width: 4.0),
                Text('${repository.stars}'),
                SizedBox(width: 16.0),
                Icon(Icons.code, size: 16.0),
                SizedBox(width: 4.0),
                Text(repository.language),
                SizedBox(width: 16.0),
                Icon(Icons.calendar_today, size: 16.0),
                SizedBox(width: 4.0),
                Text(repository.createdAt),
              ],
            ),
            SizedBox(height: 16.0),
           // ElevatedButton(
           //   onPressed: _launchUrl,
            //  child: Text('Open in GitHub'),
            //),
          ],
        ),
      ),
    );
  }
}