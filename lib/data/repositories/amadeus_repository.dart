import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:virtual_traveller_flutter/data/data_providers/remote/amadeus_api/base_data.dart';
import 'package:virtual_traveller_flutter/data/models/destination.dart';
import 'package:virtual_traveller_flutter/data/models/location.dart';
import 'dart:convert';

import 'package:virtual_traveller_flutter/data/models/poi.dart';

/// **Quick links**
///
/// *Flights related*:
/// - [getNearestAirport]
/// - [getFlightOffersSearch]
/// - [getFlightCheapestDateSearch]
/// - [getAirportCitySearch]
/// - [getAirlineCodeLookup]
///
/// *Home Page & Destinations related*:
/// - [getFlightMostBooked]
/// - [getFlightMostTravelled]
/// - [getTravelRecommendation]
/// - [getHotelSearch]
/// - [getPointsOfInterest]
/// - [getSafePlace]
class AmadeusRepository {
  AmadeusRepository({
    @required this.amadeusBaseDataProvider,
  }) : assert(amadeusBaseDataProvider != null);

  final AmadeusBaseDataProvider amadeusBaseDataProvider;

  // Flights related
  // TODO
  Future<List<dynamic>> getNearestAirport(
    Location location,
  ) async {
    final rawData = await amadeusBaseDataProvider.getRawNearestAirport(location);
    final data = json.decode(rawData)['data'];

    return data;
  }

  // TODO
  Future<dynamic> getFlightOffersSearch({
    @required String originCity,
    @required String destinationCity,
    @required String departureDate,
    String returnDate,
    @required int adults,
    int children = 0,
    int infants = 0,
    String travelClass,
    bool nonStop,
    String currencyCode = 'USD',
    int maxPrice,
  }) async {
    final rawData = await amadeusBaseDataProvider.getRawFlightOffersSearch(
    originCity: originCity,
    destinationCity: destinationCity,
    departureDate: departureDate,
    returnDate: returnDate,
    adults: adults,
    children: children,
    infants: infants,
    travelClass: travelClass,
    nonStop: nonStop,
    currencyCode: currencyCode,
    maxPrice: maxPrice,
    );
    final data = json.decode(rawData)['data'];
    final dictionaries = json.decode(rawData)['dictionaries'];

    return [data, dictionaries];
  }

  // TODO
  Future<dynamic> getFlightCheapestDateSearch({
    @required String originCity,
    @required String destinationCity,
  }) async {
    final rawData = await amadeusBaseDataProvider.getRawFlightCheapestDateSearch(
      originCity: originCity,
      destinationCity: destinationCity,
    );
    final data = json.decode(rawData)['data'];
    final dictionaries = json.decode(rawData)['dictionaries'];

    return [data, dictionaries];
  }

  // TODO
  Future<List<dynamic>> getAirportCitySearch(
    String textSearchKeyword,
  ) async {
    final rawData = await amadeusBaseDataProvider.getRawAirportCitySearch(textSearchKeyword);
    final data = json.decode(rawData)['data'];

    return data;
  }

  // TODO
  Future<dynamic> getAirlineCodeLookup(
    String airlineCode,
  ) async {
    final rawData = await amadeusBaseDataProvider.getRawAirlineCodeLookup(airlineCode);
    final data = json.decode(rawData)['data'][0];

    return data;
  }

  // Home Page & Destinations related
  // TODO
  Future<List<dynamic>> getFlightMostBooked(
    String originCityCode,
  ) async {
    final rawData = await amadeusBaseDataProvider.getRawFlightMostBooked(originCityCode);
    final data = json.decode(rawData)['data'];

    return data;
  }

  Future<List<Destination>> getFlightMostTravelled(
    String originCityCode,
  ) async {
    final rawData = await amadeusBaseDataProvider.getRawFlightMostTravelled(originCityCode);
    final data = json.decode(rawData)['data'];

    final destinations = (data as List).map((item) {
      return Destination.fromJson(item);
    }).toList();

    return destinations;
  }

  // TODO
  Future<List<dynamic>> getTravelRecommendation(
    List<String> cityCodes,
  ) async {
    final rawData = await amadeusBaseDataProvider.getRawTravelRecommendation(cityCodes);
    final data = json.decode(rawData)['data'];

    return data;
  }

  // TODO
  Future<dynamic> getHotelSearch({
    @required cityCode,
    String language,
  }) async {
    final rawData = await amadeusBaseDataProvider.getRawHotelSearch(
      cityCode: cityCode,
      language: language,
    );
    // TODO: convert {newline} back to \n when doing in model fromJson
    // json decode produces an error if there is a newline \n
    final escapedData = rawData.replaceAll('\n', '{newline}');

    final data = json.decode(escapedData)['data'];
    final dictionaries = json.decode(escapedData)['dictionaries'];

    return [data, dictionaries];
  }

  // TODO
  Future<List<dynamic>> getPointsOfInterest(
    Location location,
    List<CategoryPOI> categories,
  ) async {
    final strList = categories.map((category) => describeEnum(category)).toList();

    final rawData = await amadeusBaseDataProvider.getRawPointsOfInterest(
      location: location,
      categories: strList,
    );
    final data = json.decode(rawData)['data'];

    return data;
  }

  // TODO
  Future<List<dynamic>> getSafePlace(
    Location location,
  ) async {
    final rawData = await amadeusBaseDataProvider.getRawSafePlace(location);
    final data = json.decode(rawData)['data'];

    return data;
  }
}
