// ignore_for_file: unused_local_variable, unrelated_type_equality_checks, body_might_complete_normally_catch_error

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walesa/page/home_page.dart';
import 'package:walesa/page/live_page.dart';
import 'package:walesa/provider/dark_theme_provider.dart';
import 'package:walesa/splash_screen.dart';
import 'package:walesa/widgets/dark_theme.dart';
import 'package:walesa/widgets/search_screen.dart';
import 'page/movie_page.dart';

void main() {
  // debugPrint = (String? message, {int? wrapWidth}) {};
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 AppUpdateInfo? _updateInfo;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

bool _flexibleUpdateAvailable = false;

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> checkForUpdate() async {
  InAppUpdate.checkForUpdate().then((info) {
    setState(() {
      _updateInfo = info;
      if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
        showUpdateDialog(context);
      }
    });
  }).catchError((e) {
    showSnack(e.toString());
  });
}

void showSnack(String text) {
  if (_scaffoldKey.currentContext != null) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
  }
}

void showUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update Available'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('A new update is available. Do you want to update?'),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Accept'),
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
              if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
                InAppUpdate.performImmediateUpdate().catchError((e) {
                  showSnack(e.toString());
                });
              }
            },
          ),
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
          ),
        ],
      );
    },
  );
}

  DarkThemeProvider themeChandeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChandeProvider.darkTheme =
        await themeChandeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    checkForUpdate();
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChandeProvider;
        }),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Eklezia',
            theme: Styles.themeData(themeChandeProvider.darkTheme, context),
            initialRoute: '/',
            routes: {
              '/': (context) => const Splash(),
              '/home': (context) => HomePage(),
              '/movie': (context) => const VideoPage(),
              '/live': (context) => LivePage(
                    videoUrl: '',
                    videoTitre: '',
                  ),
              '/search': (context) => SearchPage(videoItems)
            },
          );
        },
      ),
    );
  }
}
