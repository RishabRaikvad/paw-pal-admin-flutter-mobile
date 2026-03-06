import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Gender { male, female }

enum HavePet { yes, no }

enum VariantType { weight, size, none }

class Constant {
  static String razorPayKey = "razorpayKey";
  static String stateWiseCityApiKey = "stateWiseCityApiKey";
  static const String fontFamily = "Outfit";
  static const int staticCount = 6;

  // api url
  static final String stateWiseCityApi =
      "https://api.countrystatecity.in/v1/countries/IN/states";

  static TimeOfDay stringToTimeOfDay(String time) {
    final format = DateFormat.jm(); // 10:30 AM
    final dateTime = format.parse(time);
    return TimeOfDay.fromDateTime(dateTime);
  }

  /// TimeOfDay → String
  static String timeOfDayToString(TimeOfDay time) {
    final now = DateTime.now();

    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    return DateFormat.jm().format(dateTime);
  }
}
