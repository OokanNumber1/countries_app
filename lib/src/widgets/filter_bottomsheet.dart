import 'package:countries_app/src/model/continent.dart';
import 'package:countries_app/src/model/time_zone.dart';
import 'package:countries_app/src/shared/colors.dart';
import 'package:flutter/material.dart';

import '../model/filter_response.dart';

class FilterBottomsheet extends StatefulWidget {
  const FilterBottomsheet({super.key});

  @override
  State<FilterBottomsheet> createState() => _FilterBottomsheetState();
}

class _FilterBottomsheetState extends State<FilterBottomsheet> {
  FilterOption filterOption = FilterOption.none;
  List<Continent> continents = [
    Continent("Africa", false),
    Continent("Antarctica", false),
    Continent("Asia", false),
    Continent("Australia", false),
    Continent("Europe", false),
    Continent("North America", false),
    Continent("South America", false),
  ];
  Set<String> selectedContinent = {};
  List<TimeZone> timeZones = [
    TimeZone("UTC+01:00", false),
    TimeZone("UTC+02:00", false),
    TimeZone("UTC+03:00", false),
    TimeZone("UTC+04:00", false),
    TimeZone("UTC+05:00", false),
    TimeZone("UTC+06:00", false),
    TimeZone("UTC+07:00", false),
    TimeZone("UTC-06:00", false),
  ];
  Set<String> selectedTimeZone = {};

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final filterVar = selectedContinent;
    filterVar.addAll(selectedTimeZone);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Filter"),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'x',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Continent"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filterOption = filterOption == FilterOption.continent
                              ? FilterOption.none
                              : FilterOption.continent;
                        });
                      },
                      icon: Icon(filterOption == FilterOption.continent
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                    )
                  ],
                ),
                Visibility(
                  visible: filterOption == FilterOption.continent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      continents.length,
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            continents[index].text,
                          ),
                          Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            fillColor: const MaterialStatePropertyAll(
                                AppColors.grayWarm),
                            value: continents[index].isSelected,
                            onChanged: (value) => setState(() {
                              continents[index].isSelected = value!;
                              selectedContinent.contains(continents[index].text)
                                  ? selectedContinent
                                      .remove(continents[index].text)
                                  : selectedContinent
                                      .add(continents[index].text);
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Time Zone"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filterOption = filterOption == FilterOption.timeZone
                              ? FilterOption.none
                              : FilterOption.timeZone;
                        });
                      },
                      icon: Icon(filterOption == FilterOption.timeZone
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                    )
                  ],
                ),
                Visibility(
                  visible: filterOption == FilterOption.timeZone,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      timeZones.length,
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeZones[index].text,
                          ),
                          Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            fillColor: const MaterialStatePropertyAll(
                                AppColors.grayWarm),
                            value: timeZones[index].isSelected,
                            onChanged: (value) => setState(() {
                              timeZones[index].isSelected = value!;
                              selectedTimeZone.contains(timeZones[index].text)
                                  ? selectedTimeZone
                                      .remove(timeZones[index].text)
                                  : selectedTimeZone.add(timeZones[index].text);
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.08)
              ],
            ),
          ),
        ),
        Positioned(
          bottom: screenSize.height * 0.04,
          left: 24,
          child: Visibility(
            visible: filterOption == FilterOption.continent ||
                filterOption == FilterOption.timeZone,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenSize.width * 0.22, 48),
                      side: const BorderSide(color: Colors.black38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.transparent),
                  onPressed: () {
                    setState(() {
                      selectedContinent = {};
                      selectedTimeZone = {};
                      continents = continents
                          .map<Continent>((e) => e.copyWith(isSelected: false))
                          .toList();
                      timeZones = timeZones
                          .map((e) => e.copyWith(isSelected: false))
                          .toList();
                    });
                  },
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(screenSize.width * 0.55, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop<Set<String>>(
                    context,
                    filterVar,
                  ),
                  child: const Text("Show results"),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: screenSize.width * 0.32,
          child: Container(
            height: 4,
            width: screenSize.width * 0.4,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )
      ],
    );
  }
}
