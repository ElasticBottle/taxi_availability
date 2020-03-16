import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_availability/LocationMap.dart';
import 'package:taxi_availability/Services/TaxiAvailability.dart';
import 'package:taxi_availability/Services/TaxiAvailabilityAdapter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: MultiProvider(providers: [
          Provider<TaxiAvailability>(
            create: (_) => TaxiAvailabilityAdapter(),
          ),
        ], child: LocationMap()),
      ),
    );
  }
}
