import 'package:countries_app/src/model/country.dart';
import 'package:countries_app/src/provider/theme_provider.dart';
import 'package:countries_app/src/repository/country_repository.dart';
import 'package:countries_app/src/shared/colors.dart';
import 'package:countries_app/src/views/details_view.dart';
import 'package:countries_app/src/widgets/filter_bottomsheet.dart';
import 'package:countries_app/src/widgets/option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/exception.dart';

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
            ? HomeMobile(
                filterFlag: filterFlag, searchController: searchController)
            : HomeBigScreen(
                filterFlag: filterFlag, searchController: searchController));
  }
}

class HomeBigScreen extends ConsumerStatefulWidget {
  HomeBigScreen(
      {required this.filterFlag, required this.searchController, super.key});
  final TextEditingController searchController;
  Set<String> filterFlag;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeBigScreenState();
}

class _HomeBigScreenState extends ConsumerState<HomeBigScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final countriesProvider = ref.watch(countryListProvider);
    final appTheme = ref.watch(themeProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenSize.width * 0.388,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(TextSpan(
                            text: "Explore",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "ElsieSwashCaps",
                            ),
                            children: [
                              TextSpan(
                                text: ".",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.periodColor,
                                  fontFamily: "ElsieSwashCaps",
                                ),
                              )
                            ])),
                        IconButton(
                          onPressed: () {
                            ref.read(themeProvider.notifier).state =
                                appTheme == ThemeMode.light
                                    ? ThemeMode.dark
                                    : ThemeMode.light;
                          },
                          icon: Icon(
                            ref.watch(themeProvider) == ThemeMode.light
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: widget.searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 1, bottom: 1, left: 24),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        fillColor: ref.read(themeProvider) == ThemeMode.light
                            ? AppColors.gray100
                            : AppColors.gray400,
                        filled: true,
                        hintText: "Search Country",
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: ref.read(themeProvider) == ThemeMode.light
                                ? AppColors.gray500
                                : AppColors.gray200),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OptionCard(
                          icon: const Icon(Icons.language),
                          label: "EN",
                          onClick: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("English is only supported for now."),
                            ),
                          ),
                        ),
                        OptionCard(
                          icon: const Icon(Icons.filter_alt_outlined),
                          label: "Filter",
                          onClick: () => showModalBottomSheet<Set<String>>(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              builder: (context) =>
                                  const FilterBottomsheet()).then(
                            (value) => setState(() {
                              FocusScope.of(context).unfocus();
                              widget.filterFlag = value!;
                            }),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.556,
                child: countriesProvider.when(
                  data: (countries) {
                    String initial = "-";
                    if (widget.searchController.text.isNotEmpty) {
                      final searchResult = countries
                          .where(
                            (element) =>
                                element.name.toLowerCase().contains(widget
                                    .searchController.text
                                    .toLowerCase()) ||
                                element.capital.toLowerCase().contains(
                                    widget.searchController.text.toLowerCase()),
                          )
                          .toList();
                      return searchResult.isEmpty
                          ? const Center(
                              child: Text("Country not found"),
                            )
                          : SizedBox(
                              height: screenSize.height,
                              child: ListView.builder(
                                itemCount: searchResult.length,
                                itemBuilder: (context, index) =>
                                    CountryTile(country: searchResult[index]),
                              ),
                            );
                    } else if (widget.filterFlag.isNotEmpty) {
                      final filterResult = countries
                          .where(
                            (country) => widget.filterFlag.any((element) =>
                                element == country.continent ||
                                element == country.timezone),
                          )
                          .toList();
                      return filterResult.isEmpty
                          ? const Center(
                              child: Text("Country not found"),
                            )
                          : SizedBox(
                              height: screenSize.height,
                              child: ListView.builder(
                                itemCount: filterResult.length,
                                itemBuilder: (context, index) =>
                                    CountryTile(country: filterResult[index]),
                              ),
                            );
                    }

                    return SizedBox(
                      height: screenSize.height,
                      child: ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: (context, index) {
                          if (initial == countries[index].name[0]) {
                            return CountryTile(country: countries[index]);
                          } else {
                            initial = countries[index].name[0];
                            return Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(initial),
                            );
                          }
                        },
                      ),
                    );
                  },
                  error: (err, stc) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              err.toString(),
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              return ref.refresh(countryListProvider);
                            }),
                            icon: const Icon(Icons.refresh),
                          )
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeMobile extends ConsumerStatefulWidget {
  HomeMobile(
      {required this.filterFlag, required this.searchController, super.key});
  final TextEditingController searchController;

  Set<String> filterFlag;

  @override
  ConsumerState<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends ConsumerState<HomeMobile> {
  @override
  Widget build(BuildContext context) {
    final countriesProvider = ref.watch(countryListProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text.rich(TextSpan(
                              text: "Explore",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: "ElsieSwashCaps",
                              ),
                              children: [
                                TextSpan(
                                  text: ".",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.periodColor,
                                    fontFamily: "ElsieSwashCaps",
                                  ),
                                )
                              ])),
                          IconButton(
                            onPressed: () {
                              final appTheme =
                                  ref.watch(themeProvider.notifier).state;

                              ref.watch(themeProvider.notifier).state =
                                  appTheme == ThemeMode.light
                                      ? ThemeMode.dark
                                      : ThemeMode.light;
                            },
                            icon: Icon(
                              ref.watch(themeProvider) == ThemeMode.light
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        textAlign: TextAlign.center,
                        controller: widget.searchController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 1, bottom: 1, left: 24),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          prefixIcon: const Icon(Icons.search),
                          fillColor: ref.read(themeProvider.notifier).state ==
                                  ThemeMode.light
                              ? AppColors.gray100
                              : AppColors.gray400,
                          filled: true,
                          hintText: "Search Country",
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: ref.read(themeProvider.notifier).state ==
                                      ThemeMode.light
                                  ? AppColors.gray500
                                  : AppColors.gray200),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OptionCard(
                            icon: const Icon(Icons.language),
                            label: "EN",
                            onClick: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("English is only supported for now."),
                              ),
                            ),
                          ),
                          OptionCard(
                            icon: const Icon(Icons.filter_alt_outlined),
                            label: "Filter",
                            onClick: () => showModalBottomSheet<Set<String>>(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                builder: (context) =>
                                    const FilterBottomsheet()).then(
                              (value) => setState(() {
                                FocusScope.of(context).unfocus();
                                widget.filterFlag = value!;
                              }),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: 12),
              countriesProvider.when(
                data: (countries) {
                  String initial = "-";
                  if (widget.searchController.text.isNotEmpty) {
                    final searchResult = countries
                        .where(
                          (element) =>
                              element.name.toLowerCase().contains(
                                  widget.searchController.text.toLowerCase()) ||
                              element.capital.toLowerCase().contains(
                                  widget.searchController.text.toLowerCase()),
                        )
                        .toList();
                    return searchResult.isEmpty
                        ? const Center(
                            child: Text("Country not found"),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: searchResult.length,
                              itemBuilder: (context, index) =>
                                  CountryTile(country: searchResult[index]),
                            ),
                          );
                  } else if (widget.filterFlag.isNotEmpty) {
                    final filterResult = countries
                        .where(
                          (country) => widget.filterFlag.any((element) =>
                              element == country.continent ||
                              element == country.timezone),
                        )
                        .toList();
                    return filterResult.isEmpty
                        ? const Center(
                            child: Text("Country not found"),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: filterResult.length,
                                itemBuilder: (context, index) =>
                                    CountryTile(country: filterResult[index])),
                          );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        if (initial == countries[index].name[0]) {
                          return CountryTile(country: countries[index]);
                        } else {
                          initial = countries[index].name[0];
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(initial),
                          );
                        }
                      },
                    ),
                  );
                },
                error: (err, stc) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            err.toString(),
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                            onPressed: () => setState(() {
                                  // isRefreshing = true;
                                  return ref.refresh(countryListProvider);

                                  //     isRefreshing = false;
                                  //await ref.watch(countryRepoProvider.notifier).fetchCountries();
                                }),
                            icon: const Icon(Icons.refresh))
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
class CustomHeader extends StatefulWidget {
  CustomHeader(
      {required this.filterFlag, required this.searchController, super.key});
  final TextEditingController searchController;

  Set<String> filterFlag;

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text.rich(TextSpan(
                text: "Explore",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "ElsieSwashCaps",
                ),
                children: [
                  TextSpan(
                    text: ".",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.periodColor,
                      fontFamily: "ElsieSwashCaps",
                    ),
                  )
                ])),
            IconButton(
              onPressed: () {
                setState(() {
                  isLightTheme = !isLightTheme;
                });
              },
              icon: Icon(
                isLightTheme
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          textAlign: TextAlign.center,
          controller: widget.searchController,
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 1, bottom: 1, left: 24),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            prefixIcon: const Icon(Icons.search),
            fillColor: isLightTheme ? AppColors.lightFill : AppColors.darkFill,
            filled: true,
            hintText: "Search Country",
            hintStyle: TextStyle(
                fontSize: 14,
                color: isLightTheme ? AppColors.gray500 : AppColors.gray200),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OptionCard(
              icon: const Icon(Icons.language),
              label: "EN",
              onClick: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("English is only supported for now."),
                ),
              ),
            ),
            OptionCard(
              icon: const Icon(Icons.filter_alt_outlined),
              label: "Filter",
              onClick: () => showModalBottomSheet<Set<String>>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  builder: (context) => const FilterBottomsheet()).then(
                (value) => setState(() {
                  FocusScope.of(context).unfocus();
                  widget.filterFlag = value!;
                }),
              ),
            )
          ],
        ),
      ],
    );
  }
}*/

class CountryTile extends StatelessWidget {
  const CountryTile({
    Key? key,
    required this.country,
  }) : super(key: key);

  final Country country;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ListTile(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsView(country: country),
          ),
        );
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 40,
          width: 40,
          child: Image.network(
            country.flag,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        country.name,
        style: theme.labelMedium,
      ),
      subtitle: Text(
        country.capital,
        style: theme.titleSmall,
      ),
    );
  }
}
