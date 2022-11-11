import 'package:countries_app/src/repository/country_repository.dart';
import 'package:countries_app/src/shared/colors.dart';
import 'package:countries_app/src/widgets/filter_bottomsheet.dart';
import 'package:countries_app/src/widgets/option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/styles.dart';
import '../../widgets/country_tile.dart';

class HomeMobileScreen extends ConsumerStatefulWidget {
  HomeMobileScreen(
      {required this.filterFlag, required this.searchController, super.key});
  final TextEditingController searchController;

  Set<String> filterFlag;

  @override
  ConsumerState<HomeMobileScreen> createState() => _HomeMobileState();
}

class _HomeMobileState extends ConsumerState<HomeMobileScreen> {
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
                              final appTheme = ref.watch(themeProvider);

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
                          prefixIcon: Icon(
                            Icons.search,
                            color: ref.watch(themeProvider) == ThemeMode.dark
                                ? Colors.white54
                                : Colors.black54,
                          ),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("...Trying to get countries..."),
                              ),
                            );
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
            ],
          ),
        ),
      ),
    );
  }
}
