import 'package:flutter/material.dart';
import 'package:ttic/favorites_page.dart';
import 'package:ttic/main.dart';
import 'package:ttic/search_page.dart';
import 'package:ttic/settings_page.dart';

void handleItemTapped(BuildContext context, int index) {
  if (index == 0) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration(milliseconds: 250), // Set the duration of the transition
        pageBuilder: (_, __, ___) => HomePage(), // Build the destination page
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          // Define the custom transition animation
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  } else if (index == 1) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration(milliseconds: 250), // Set the duration of the transition
        pageBuilder: (_, __, ___) => SearchPage(), // Build the destination page
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          // Define the custom transition animation
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  } else if (index == 2) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration(milliseconds: 250), // Set the duration of the transition
        pageBuilder: (_, __, ___) =>
            FavoritesPage(), // Build the destination page
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          // Define the custom transition animation
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  } else if (index == 3) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration(milliseconds: 250), // Set the duration of the transition
        pageBuilder: (_, __, ___) =>
            SettingsPage(), // Build the destination page
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          // Define the custom transition animation
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  } else {
    // Handle other navigation items
  }
}
