/// Date helpers used to phrase the dashboard greeting.
extension DateTimeX on DateTime {
  /// Rough part of day, matching the three greetings the app ships.
  DayPart get dayPart {
    if (hour < 12) return DayPart.morning;
    if (hour < 17) return DayPart.afternoon;
    return DayPart.evening;
  }
}

enum DayPart { morning, afternoon, evening }
