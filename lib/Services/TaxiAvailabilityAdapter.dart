import 'dart:async';

import 'package:taxi_availability/Services/TaxiAvailability.dart';
import 'package:http/http.dart' as http;

class TaxiAvailabilityAdapter implements TaxiAvailability {
  StreamController<String> streamController = StreamController();
  Stream<String> get stream => streamController.stream;

  // void newMessage(int number, String message) {
  //   final duration = Duration(seconds: number);
  //   Timer.periodic(duration, (Timer t) => streamController.add(message));
  // }

  @override
  List<String> availableTaxis(DateTime time) {
    // TODO: implement availableTaxis
    throw UnimplementedError();
  }

  void initState() {
    // streamController.stream.listen((messages) => print(messages));

    // newMessage(1, 'You got a message!');
  }

  void dispose() {
    streamController.close();
  }
}
