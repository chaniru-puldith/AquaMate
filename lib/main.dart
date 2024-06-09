import 'package:aquamate/screens/home_screen.dart';
import 'package:aquamate/screens/signin_screen.dart';
import 'package:aquamate/screens/signup_screen.dart';
import 'package:aquamate/screens/welcome_screen.dart';
import 'package:aquamate/services/notifi_service.dart';
import 'package:aquamate/utils/styles.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: "basic_channel_group",
        channelKey: "basic_channel",
        channelName: "Reminder Notification",
        channelDescription: "Test notifications channel")
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Reminder",
    )
  ]);
  bool isAllowedNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF121212),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF121212),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    final user = FirebaseAuth.instance.currentUser;
    Widget screen;
    if (user != null) {
      screen = const HomeScreen();
    } else {
      screen = const WelcomeScreen();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(context),
      initialRoute: '/',
      routes: {
        '/': (context) => screen,
        '/welcome': (context) => const WelcomeScreen(),
        '/signin': (context) => const SigninScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
