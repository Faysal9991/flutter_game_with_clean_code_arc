extension StringX on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension NumX on num {
  double toRadians() => this * (3.141592653589793 / 180.0);
}
