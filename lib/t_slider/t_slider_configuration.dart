import 'package:flutter/rendering.dart';
import 'package:t_slider/t_slider/t_range.dart';
import 'package:t_slider/t_slider/t_slider_track_style.dart';

class TSliderConfiguration {
  const TSliderConfiguration({
    required this.value,
    this.range = const TRange(min: 0, max: 0),
    this.alignment = const Alignment(-1, 0),
    this.trackStyle = const TSliderTrackStyle(
      radius: BorderRadius.all(Radius.circular(double.infinity)),
      color: Color(0xffffffff),
    ),
  });

  final TRange range;
  final double value;
  final Alignment alignment;
  final TSliderTrackStyle trackStyle;

  bool validate() {
    assert(range.inRange(value) == true, "The value must be in the range");
    return true;
  }

  TSliderConfiguration cloneWith({
    TRange? range,
    double? value,
    Alignment? alignment,
    TSliderTrackStyle? trackStyle,
  }) {
    return TSliderConfiguration(
      range: range ?? this.range,
      value: value ?? this.value,
      alignment: alignment ?? this.alignment,
      trackStyle: this.trackStyle.cloneWith(
            border: trackStyle?.border,
            color: trackStyle?.color,
            radius: trackStyle?.radius,
          ),
    );
  }
}
