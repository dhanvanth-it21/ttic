import 'package:flutter/material.dart';
import 'package:ttic/bottom_navigation_handler.dart';
import 'bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Favorites Page'),
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

void _saveActivity(String imagePath, String extractedText) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Get the existing activities from shared preferences
  List<String>? activities = prefs.getStringList('activities');

  // Create a new activity entry
  String newActivity = '$imagePath|$extractedText';

  // Add the new activity to the list
  if (activities == null) {
    activities = [newActivity];
  } else {
    activities.insert(0, newActivity);

    // Limit the list to the last 10 activities
    if (activities.length > 10) {
      activities = activities.sublist(0, 10);
    }
  }

  // Save the updated list of activities to shared preferences
  prefs.setStringList('activities', activities);
}
