import 'dart:convert';
import 'dart:io';

import 'package:covid_19_tracker/app/services/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class APIService {
  final API api;

  APIService(this.api);

  Future<String> getAccessToken() async {
    final response = await http.post(api.tokenUri.toString(),
        headers: {HttpHeaders.authorizationHeader: "Basic ${api.apiKey}"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data["access_token"];
      if (accessToken != null)
        return accessToken;
      else
        throw response;
    }
  }

  Future<int> getEndpointData(
      {@required String accessToken, @required Endpoint endpoint}) async {
    final Uri uri = api.endpointUri(endpoint);
    final response = await http.get(uri.toString(),
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonKey = _responseJsonKey[endpoint];
        final int result = endpointData[responseJsonKey];
        if (result != null) return result;
      }
    } else
      throw response;
  }

  static Map<Endpoint, String> _responseJsonKey = {
    Endpoint.cases: "cases",
    Endpoint.casesSuspected: "data",
    Endpoint.casesConfirmed: "data",
    Endpoint.deaths: "data",
    Endpoint.recovered: "data"
  };
}
