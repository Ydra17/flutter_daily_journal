import 'package:flutter/material.dart';
import 'package:flutter_daily_journal/core/theme/dark_theme.dart';
import 'package:flutter_daily_journal/core/theme/light_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/journal/data/models/journal_model.dart';
import 'features/journal/presentation/pages/journal_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(JournalModelAdapter()); // jika ada model Hive
  await Hive.openBox<JournalModel>('journals');
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const JournalHomePage(),
    );
  }
}
