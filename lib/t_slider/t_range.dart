class TRange {
  const TRange({this.min = 0, this.max = 0})
      : assert(max >= min,
            'The maximum value must be greater than the minimum value.');

  final double min;
  final double max;

  bool inRange(double value) => value >= min && value <= max;

  double map(double value, TRange range) =>
      range.min + ((value - min) / (max - min)) * (range.max - range.min);
}
