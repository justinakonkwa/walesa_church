// ignore_for_file: unused_local_variable, unrelated_type_equality_checks, body_might_complete_normally_catch_error

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:walesa/page/home_page.dart';
import 'package:walesa/page/live_page.dart';
import 'package:walesa/provider/dark_theme_provider.dart';
import 'package:walesa/splash_screen.dart';
import 'package:walesa/widgets/dark_theme.dart';
import 'package:walesa/widgets/search_screen.dart';
import 'page/movie_page.dart';

void main() {
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
  void checkForUpdates() async {
    final InAppUpdate inAppUpdate = InAppUpdate();
    await InAppUpdate.checkForUpdate().then((updateAvailability) async {
      if (updateAvailability == UpdateAvailability.updateAvailable) {
        // Afficher un message à l'utilisateur pour lui demander s'il souhaite mettre à jour
        bool shouldUpdate = await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Mise à jour disponible'),
            content: const Text(
                "Une nouvelle version de l'application est disponible. Voulez-vous mettre à jour maintenant ?"),
            actions: [
              TextButton(
                child: const Text('Plus tard'),
                onPressed: () {
                  Navigator.of(context).pop(false); // Refuser la mise à jour
                },
              ),
              TextButton(
                child: const Text('Mettre à jour'),
                onPressed: () {
                  Navigator.of(context).pop(true); // Accepter la mise à jour
                },
              ),
            ],
          ),
        );

        if (shouldUpdate) {
          await InAppUpdate.performImmediateUpdate().catchError((e) {
            print('Erreur');
            // Gestion des erreurs lors du démarrage de la mise à jour immédiate.
          });
        }
      }
    }).catchError((e) {
      // Gestion des erreurs lors de la vérification des mises à jour.
    });
  }

  DarkThemeProvider themeChandeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChandeProvider.darkTheme =
        await themeChandeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    checkForUpdates();
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
