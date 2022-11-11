import 'package:countries_app/src/provider/theme_provider.dart';
import 'package:countries_app/src/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/shared/styles.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Countries App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ref.watch(themeProvider),
      home: const HomeView(),
    );
  }
}
