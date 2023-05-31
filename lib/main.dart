import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'bottom_navigation_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flu5tter UI Example',
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter UI Example'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Button 1'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle button 2 click
              },
              child: Text('Button 2'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle button 3 click
              },
              child: Text('Button 3'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          handleItemTapped(context, index);
        },
      ),
    );
  }
}
