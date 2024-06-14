import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_experiments/const_data.dart';
import 'package:flutter_experiments/routes/app_routes.dart';

final List<Map<String, dynamic>> pages = [
  {
    StaticKeys.routeKey: AppRoutes.reorderableGridScreen,
    StaticKeys.titleKey: 'Reorderable Grid',
    StaticKeys.colorKey: Colors.red
  },
  {
    StaticKeys.routeKey: AppRoutes.writeSomethingScreen,
    StaticKeys.titleKey: 'Write Something',
    StaticKeys.colorKey: Colors.pink
  },
  {
    StaticKeys.routeKey: AppRoutes.chatScreen,
    StaticKeys.titleKey: 'Chat with Gemini',
    StaticKeys.colorKey: Colors.indigo
  },
  {
    StaticKeys.routeKey: AppRoutes.parallaxScrolkScreen,
    StaticKeys.titleKey: 'Parallax scroll effect',
    StaticKeys.colorKey: Colors.blueGrey
  },
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Wrap(
            // alignment: WrapAlignment.center,
            // runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: pages.map((e) => pageCard(e)).toList(),
          ),
        ),
      ),
    );
  }

  Widget pageCard(Map<String, dynamic> configs) => FadeInUp(
        child: Container(
          width: MediaQuery.of(context).size.width * .45,
          height: MediaQuery.of(context).size.width * .50,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: (configs[StaticKeys.colorKey] as Color).withAlpha(180),
          ),
          child: Column(
            children: [
              Text(
                configs[StaticKeys.titleKey],
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: Colors.white),
                maxLines: 2,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  child: const Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    size: 50,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(configs[StaticKeys.routeKey]);
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
