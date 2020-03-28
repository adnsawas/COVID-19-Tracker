import 'package:covid_19_tracker/app/services/api.dart';
import 'package:covid_19_tracker/app/services/api_service.dart';
import 'package:flutter/material.dart';

class CoronaDataNotifier extends ChangeNotifier {
  int _cases = 0;
  int _suspectedCases = 0;
  int _confirmedCases = 0;
  int _deaths = 0;
  int _recovered = 0;

  static String accessToken = "";
  static APIService apiService;

  CoronaDataNotifier() {
    apiService = APIService(API.sandbox());
  }

  int get getCases => _cases;
  int get getSuspectedCases => _suspectedCases;
  int get getConfirmedCases => _confirmedCases;
  int get getDeaths => _deaths;
  int get getRecovered => _recovered;

  login() async {
    accessToken = await apiService.getAccessToken();
  }

  Future<List<int>> fetchAllData() async {
    var results = await Future.wait([
      apiService.getEndpointData(accessToken: accessToken, endpoint: Endpoint.cases),
      apiService.getEndpointData(accessToken: accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(accessToken: accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(accessToken: accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(accessToken: accessToken, endpoint: Endpoint.recovered)
    ]);

    _cases = results[0];
    _suspectedCases = results[1];
    _confirmedCases = results[2];
    _deaths = results[3];
    _recovered = results[4];

    notifyListeners();

    return results;
  }
}
