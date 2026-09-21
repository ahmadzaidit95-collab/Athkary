import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/adhkar/adhkar_screen.dart';
import 'features/adhkar/data/adhkar_category.dart';
import 'features/duas/duas_screen.dart';
import 'features/home/home_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/tasbeeh/tasbeeh_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = await ThemeController.load();
  runApp(
    ChangeNotifierProvider.value(
      value: themeController,
      child: const AdhkariApp(),
    ),
  );
}

class AdhkariApp extends StatelessWidget {
  const AdhkariApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeController>().mode;

    return MaterialApp(
      title: 'أذكاري',
      debugShowCheckedModeBanner: false,

      // عربي + RTL تلقائي
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,

      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/': (_) => const HomeScreen(),
        '/morning': (_) => const AdhkarScreen(category: AdhkarCategory.morning),
        '/evening': (_) => const AdhkarScreen(category: AdhkarCategory.evening),
        '/duas': (_) => const DuasScreen(),
        '/tasbeeh': (_) => const TasbeehScreen(),
      },
    );
  }
}