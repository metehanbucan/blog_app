import 'package:intl/intl.dart';

String formatDateBydMMMYYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyy").format(dateTime);
}
