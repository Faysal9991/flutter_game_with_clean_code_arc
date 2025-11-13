import 'dart:math';

class Helpers {
  static String generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(8, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  static double clamp(double value, double min, double max) {
    return value < min ? min : (value > max ? max : value);
  }
}
