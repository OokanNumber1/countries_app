import 'package:countries_app/src/repository/country_repository.dart';
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
    final countriesProvider = ref.watch(countryListProvider);
    // final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Explore"),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.light_mode),
                  )
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                textAlign: TextAlign.center,
                controller: searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: "Search Country",
                ),
              ),
              const SizedBox(height: 12),
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
                            builder: (context) => const FilterBottomsheet())
                        .then((value) => setState(() {
                          FocusScope.of(context).unfocus();
                              filterFlag = value!;
                            })),
                  )
                ],
              ),
              countriesProvider.when(
                data: (countries) {
                  String initial = "-";
                  if (searchController.text.isNotEmpty) {
                    final searchResult = countries
                        .where(
                          (element) =>
                              element.name.toLowerCase().contains(
                                  searchController.text.toLowerCase()) ||
                              element.capital.toLowerCase().contains(
                                  searchController.text.toLowerCase()),
                        )
                        .toList();
                    return searchResult.isEmpty
                        ? const Center(
                            child: Text("Country not found"),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: searchResult.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsView(country: searchResult[index]))),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.network(
                                      searchResult[index].flag,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  searchResult[index].name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  searchResult[index].capital,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          );
                  } else if (filterFlag.isNotEmpty) {
                    final filterResult = countries
                        .where(
                          (country) => filterFlag.any((element) =>
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
                              itemBuilder: (context, index) => ListTile(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsView(country: filterResult[index]))),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.network(
                                      filterResult[index].flag,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  filterResult[index].name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  filterResult[index].capital,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        if (initial == countries[index].name[0]) {
                          return ListTile(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsView(country: countries[index]))),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.network(
                                  countries[index].flag,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              countries[index].name,
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              countries[index].capital,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        } else {
                          initial = countries[index].name[0];
                          return Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Text(initial),
                          );
                        }
                      },
                    ),
                  );
                },
                error: (err, stc) {
                  err as CustomException;
                  return Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            err.message,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                            onPressed: () => setState(() {
                                  return ref.refresh(countryListProvider);
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
