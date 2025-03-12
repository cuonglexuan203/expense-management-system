import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GreetingNotifier extends StateNotifier<String> {
  GreetingNotifier() : super(_getGreetingByHour(DateTime.now().hour)) {
    _scheduleUpdates();
  }

  Timer? _timer;

  static String _getGreetingByHour(int hour) {
    if (hour < 12) {
      return 'Good morning,';
    } else if (hour < 17) {
      return 'Good afternoon,';
    } else if (hour < 21) {
      return 'Good evening,';
    } else {
      return 'Good night,';
    }
  }

  void _scheduleUpdates() {
    final now = DateTime.now();
    DateTime nextUpdate;

    if (now.hour < 12) {
      nextUpdate = DateTime(now.year, now.month, now.day, 12, 0);
    } else if (now.hour < 17) {
      nextUpdate = DateTime(now.year, now.month, now.day, 17, 0);
    } else if (now.hour < 21) {
      nextUpdate = DateTime(now.year, now.month, now.day, 21, 0);
    } else {
      final tomorrow = now.add(const Duration(days: 1));
      nextUpdate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0);
    }

    final timeUntilNextUpdate = nextUpdate.difference(now);
    _timer?.cancel();

    _timer = Timer(timeUntilNextUpdate, () {
      state = _getGreetingByHour(DateTime.now().hour);
      _scheduleUpdates();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final greetingProvider = StateNotifierProvider<GreetingNotifier, String>((ref) {
  return GreetingNotifier();
});
