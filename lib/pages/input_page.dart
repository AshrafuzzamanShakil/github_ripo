import 'package:flutter/material.dart';
import 'package:github_rioi/pages/home_page.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  bool _isDarkMode = false;
  ValueNotifier<ThemeData> _themeNotifier = ValueNotifier(ThemeData.light());

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _themeNotifier.value = _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }


  final TextEditingController usernameController = TextEditingController();

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub User'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Enter GitHub username',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final username = usernameController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(username: username),
                  ),
                );
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

