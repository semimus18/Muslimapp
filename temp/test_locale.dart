import 'package:hijri_calendar/hijri_calendar.dart'; void main() { final config = HijriCalendarConfig.now(); print('Locale:'); config.locale = 'ms'; print(config.getLongMonthName()); }
