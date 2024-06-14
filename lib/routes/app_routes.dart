import 'package:flutter/material.dart';
import 'package:flutter_experiments/screens/chat_screen.dart';
import 'package:flutter_experiments/screens/home_screen.dart';
import 'package:flutter_experiments/screens/reordleable_grid_screen.dart';
import 'package:flutter_experiments/screens/parallax_scroll_screen.dart';
import 'package:flutter_experiments/screens/write_something_screen.dart';

class AppRouter {
  static getRoutes() => <String, Widget Function(BuildContext)>{
        AppRoutes.homeScreen: (context) => const HomeScreen(),
        AppRoutes.reorderableGridScreen: (context) =>
            const ReorderableGridScreen(),
        AppRoutes.writeSomethingScreen: (context) =>
            const WriteSomethingScreen(),
        AppRoutes.chatScreen: (context) => const ChatScreen(),
        AppRoutes.parallaxScrolkScreen: (context) =>
            const ParallaxScollScreen(),
      };
}

class AppRoutes {
  static const String homeScreen = '/home';
  static const String reorderableGridScreen = '/reorderable_grid_screen';
  static const String writeSomethingScreen = '/write_something';
  static const String chatScreen = '/chatScreen';
  static const String parallaxScrolkScreen = '/parallax_scroll_screen';
}
