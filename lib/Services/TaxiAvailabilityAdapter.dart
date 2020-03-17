import 'dart:async';
import 'dart:convert';

import 'package:taxi_availability/Services/TaxiAvailability.dart';
import 'package:http/http.dart' as http;
import 'package:taxi_availability/json/Response.dart';

class TaxiAvailabilityAdapter implements TaxiAvailability {
  final String _url = "https://api.data.gov.sg/v1/transport/taxi-availability";
  final int _success = 200;
  final int _UTC8 = 8;
  @override
  Future markers(DateTime dateTime) async {
    print("getting markers");
    String timeToRequest = dateTime
        .add(Duration(hours: _UTC8))
        .toIso8601String()
        .substring(0, 19)
        .replaceAll(":", "%3A");
    print(timeToRequest);
    String getUrl = _url + "?date_time=" + timeToRequest;
    print(getUrl);
    http.Response response;
    try {
      response = await http.get(getUrl);
    } catch (e) {
      throw http.ClientException;
    }
    if (response.statusCode == _success) {
      Map<String, dynamic> content = json.decode(response.body);
      CabDetails result = CabDetails.fromJson(content["features"][0]);
      List<List<double>> coordinates = result.cabCoordinates.coordinates;
      return coordinates;
    } else {
      print("Bad request");
    }
  }
}
