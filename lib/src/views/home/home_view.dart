import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_big_screen.dart';
import 'home_mobile_screen.dart';


class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late final TextEditingController searchController;
  Set<String> filterFlag = {};
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth <= 620
            ? HomeMobileScreen(
                filterFlag: filterFlag, searchController: searchController)
            : HomeBigScreen(
                filterFlag: filterFlag, searchController: searchController));
  }
}
