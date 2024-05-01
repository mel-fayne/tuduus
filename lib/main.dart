import 'package:activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:quickeydb/quickeydb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuduus/app/home.dart';
import 'package:tuduus/app/onboarding.dart';
import 'package:tuduus/data/board.dart';
import 'package:tuduus/data/schemas/board_schema.dart';
import 'package:tuduus/data/schemas/task_schema.dart';
import 'package:tuduus/main_controller.dart';
import 'package:tuduus/themes.dart';

import 'utils/constants.dart';

bool? isUserOnboarded = false;

Future<bool?> checkIsOnboarded() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isOnboarded = prefs.getBool('isOnboarded');
  return isOnboarded;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isUserOnboarded = await checkIsOnboarded();
  await QuickeyDB.initialize(
    persist: false,
    dbVersion: 1,
    dataAccessObjects: [
      BoardSchema(),
      TaskSchema(),
    ],
    dbName: 'tuduus_v1',
  );
  if (isUserOnboarded != true) {
    await QuickeyDB.getInstance!<BoardSchema>()?.create(
      Board(title: defaultBoard),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: tuduusLightTheme,
      darkTheme: tuduusDarkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: isUserOnboarded == true
          ? HomeView.routeName
          : OnboardingView.routeName,
      home: Activity(
        MainController(),
        onActivityStateChanged: () =>
            DateTime.now().microsecondsSinceEpoch.toString(),
        child: HomeView(
          activeController: MainController(),
        ),
      ),
      routes: {
        OnboardingView.routeName: (context) => OnboardingView(
              activeController: MainController(),
            ),
        HomeView.routeName: (context) => Activity(
              MainController(),
              onActivityStateChanged: () =>
                  DateTime.now().microsecondsSinceEpoch.toString(),
              child: HomeView(
                activeController: MainController(),
              ),
            ),
      },
    );
  }
}
