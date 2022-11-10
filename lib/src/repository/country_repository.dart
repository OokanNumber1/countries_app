import 'dart:developer';

import 'package:countries_app/src/shared/exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/country.dart';

class CountryRepository  extends StateNotifier<List<Country>>{
   CountryRepository({required this.dioClient}) : super([]);
  final Dio dioClient;

  Future<List<Country>> fetchCountries() async {
    try {
      final response =
          await dioClient.get("https://restcountries.com/v3.1/all");
      //log(response.data!.toString());
      final respData = response.data as List;
      
      final returnedData =
          respData.map((rawCountry) => Country.fromMap(rawCountry)).toList();
      
      returnedData.sort((a, b) => a.name[0].compareTo(b.name[0]));
      state = returnedData;
      return returnedData;
    } on DioError catch (e) {
      log(e.message);
      throw CustomException(message: e.message);
    }
  }
}

final countryRepoProvider = StateNotifierProvider<CountryRepository, List<Country>>((ref) {
  return CountryRepository(dioClient: Dio());
});

final countryListProvider = FutureProvider<List<Country>>((ref) async {
  return ref.read(countryRepoProvider.notifier).fetchCountries();
});
