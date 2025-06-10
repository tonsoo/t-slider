import 'package:flutter/rendering.dart';

class TSliderTrackStyle {
  const TSliderTrackStyle({
    this.color,
    this.radius,
    this.border,
  });

  final Color? color;
  final BorderRadius? radius;
  final Border? border;

  TSliderTrackStyle cloneWith({
    Color? color,
    BorderRadius? radius,
    Border? border,
  }) {
    return TSliderTrackStyle(
      color: color ?? this.color,
      radius: radius ?? this.radius,
      border: border ?? this.border,
    );
  }
}
