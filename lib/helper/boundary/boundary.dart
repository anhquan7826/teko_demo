class ValueBoundary {
  ValueBoundary._();

  static num bound({required num min, required num max, required num value}) {
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }
}