import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String moneyFormat(String price) {
  if (price.isEmpty) {
    return '0.00'; // Return '0.00' for empty or invalid input
  }

  double parsedPrice = double.tryParse(price) ?? 0.00;
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_US', // Use your desired locale here
    symbol:
        '', // Set to your desired currency symbol (e.g., '$', '€', '£', etc.)
    decimalDigits: 2, // Number of decimal digits to show
  );

  return currencyFormatter.format(parsedPrice);
}

String getCreatedAt(Timestamp time) {
  int seconds = DateTime.now().difference(time.toDate()).inSeconds;
  int minutes = DateTime.now().difference(time.toDate()).inMinutes;
  int hours = DateTime.now().difference(time.toDate()).inHours;
  int days = DateTime.now().difference(time.toDate()).inDays;
  double months = DateTime.now().difference(time.toDate()).inDays / 30;

  if (seconds < 60) {
    return "$seconds secs ago";
  }
  if (minutes < 60) {
    return "$minutes mins ago";
  }
  if (hours < 24) {
    return "$hours hours ago";
  }
  if (days == 1) {
    return "$days day ago";
  }
  if (days < 30) {
    return "$days days ago";
  } else if (months < 12) {
    return "${months.floor()} months ago";
  }
  return "${(months / 12).floor()} years ago";
}
