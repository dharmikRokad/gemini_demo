import 'package:flutter/material.dart';
import 'package:gemini_demo/chat_screen.dart';
import 'package:gemini_demo/home_screen.dart';
import 'package:gemini_demo/reordleable_grid_screen.dart';
import 'package:gemini_demo/write_something_screen.dart';

class AppRouter {
  static getRoutes() => <String, Widget Function(BuildContext)>{
        AppRoutes.homeScreen: (context) => const HomeScreen(),
        AppRoutes.reorderableGridScreen: (context) =>
            const ReorderableGridScreen(),
        AppRoutes.writeSomethingScreen: (context) =>
            const WriteSomethingScreen(),
        AppRoutes.chatScreen: (context) => const ChatScreen(),
      };
}

class AppRoutes {
  static const String homeScreen = '/home';
  static const String reorderableGridScreen = '/reorderable_grid_screen';
  static const String writeSomethingScreen = '/write_something';
  static const String chatScreen = '/chatScreen';
}
