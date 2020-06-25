import 'package:app_recipes/viewmodal/newsArticleViewModalList.dart';
import 'package:app_recipes/widgets/googleMap.dart';
import 'package:app_recipes/widgets/savedItems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_recipes/widgets/newsListPage.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      home: ChangeNotifierProvider(
        create: (context) => NewsArticleViewModelList(),
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [NewsList(), GoogleDoc(), AiPage()];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
      selectedItemColor: Colors.indigo,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('NEWS'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            title: Text('LOCALISATION'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('PROFILE'))
        ],
      ),
    );
  }
}
