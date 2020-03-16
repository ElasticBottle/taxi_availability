import 'dart:async';
import 'dart:convert';

import 'package:taxi_availability/Services/TaxiAvailability.dart';
import 'package:http/http.dart' as http;

class TaxiAvailabilityAdapter implements TaxiAvailability {
  final String _url = "https://api.data.gov.sg/v1/transport/taxi-availability";

  @override
  Future markers(DateTime dateTime) async {
    print("getting markers");
    print(DateTime.now());
    http.Response response = await http.get(_url);
    Map<String, dynamic> content = json.decode(response.body);
    print(content);
    return Future.value(null);
  }

  void initState() {}

  void dispose() {}
}
