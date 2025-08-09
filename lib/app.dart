import 'package:flutter/material.dart';
import 'package:flutter_daily_journal/core/theme/dark_theme.dart';
import 'package:flutter_daily_journal/core/theme/light_theme.dart';
import 'package:flutter_daily_journal/features/journal/presentation/pages/journal_home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Journal',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const JournalHomePage(),
    );
  }
}
