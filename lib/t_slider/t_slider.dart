import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:t_slider/t_slider/t_range.dart';
import 'package:t_slider/t_slider/t_slider_configuration.dart';
import 'package:t_slider/t_slider/t_slider_track_style.dart';
import 'package:t_slider/t_slider/t_slider_wrap.dart';

class TSlider extends StatelessWidget {
  const TSlider({
    super.key,
    this.background = const TSliderTrackStyle(
      color: Color(0xffededed),
    ),
    this.primary = const TSliderConfiguration(
      value: 0,
      range: TRange(min: 0, max: 0),
    ),
    this.secondary,
    this.wrap = TSliderWrap.loose,
    this.onDragged,
  });

  final TSliderTrackStyle background;
  final TSliderConfiguration primary;
  final TSliderConfiguration? secondary;
  final TSliderWrap wrap;

  final void Function(double value)? onDragged;

  @override
  Widget build(BuildContext context) {
    assert(primary.validate(), 'Primary settings are not valid');

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = switch (wrap) {
          TSliderWrap.tight => constraints.minWidth,
          TSliderWrap.loose => constraints.maxWidth,
        };
        final height = switch (wrap) {
          TSliderWrap.tight => constraints.minHeight,
          TSliderWrap.loose => constraints.maxHeight,
        };
        return Container(
          decoration: BoxDecoration(
            color: background.color,
            border: background.border,
            borderRadius: background.radius,
          ),
          clipBehavior: Clip.none,
          child: _Tracks(
            secondary: secondary,
            width: width,
            height: height,
            primary: primary,
            onDragged: onDragged,
          ),
        );
      },
    );
  }
}

class _Tracks extends StatefulWidget {
  const _Tracks({
    required this.secondary,
    required this.width,
    required this.height,
    required this.primary,
    required this.onDragged,
  });

  final TSliderConfiguration? secondary;
  final double width;
  final double height;
  final TSliderConfiguration primary;

  final void Function(double value)? onDragged;

  @override
  State<_Tracks> createState() => _TracksState();
}

class _TracksState extends State<_Tracks> {
  bool dragging = false;

  Point? _startPoint;
  set startPoint(Point? point) {
    if (point == _startPoint) return;
    setState(() {
      _startPoint = point;
    });
  }

  double? _getValue({Point? point}) {
    point ??= _startPoint;
    if (point?.x == null) return null;

    final draggedPercentage = point!.x.toDouble() / widget.width;
    return widget.primary.range.map(
      draggedPercentage,
      TRange(min: 0, max: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final value = _getValue();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (widget.secondary != null)
          _Track(
            configuration: widget.secondary!,
            size: Size(widget.width, widget.height),
          ),
        _Track(
          configuration: widget.primary.cloneWith(value: value),
          size: Size(widget.width, widget.height),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () => print('a'),
            onTapDown: (details) => _dispatchDragEnd(
              point: Point(
                details.globalPosition.dx,
                details.globalPosition.dy,
              ),
            ),
            onHorizontalDragStart: _dragStart,
            onHorizontalDragUpdate: _dragUpdate,
            onHorizontalDragEnd: _dragEnd,
            dragStartBehavior: DragStartBehavior.down,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: SizedBox(
                width: widget.width + 20,
                height: widget.height + 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _dragStart(DragStartDetails details) {
    final pos = details.globalPosition;
    startPoint = Point(pos.dx, pos.dy);
  }

  void _dragUpdate(DragUpdateDetails details) {
    final pos = details.globalPosition;
    startPoint = Point(pos.dx, pos.dy);
  }

  void _dragEnd(DragEndDetails details) {
    _dispatchDragEnd();
    startPoint = null;
  }

  void _dispatchDragEnd({Point? point}) {
    final value = _getValue(point: point);
    if (widget.onDragged != null && value != null) {
      widget.onDragged!(value);
    }
  }
}

class _Track extends StatelessWidget {
  const _Track({
    required this.configuration,
    required this.size,
  });

  final TSliderConfiguration configuration;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final percentage = configuration.value / configuration.range.max;
    final width = size.width * percentage;
    final style = configuration.trackStyle;
    return Positioned.fill(
      child: Align(
        alignment: configuration.alignment,
        child: Container(
          width: width.clamp(0, size.width).toDouble(),
          height: size.height,
          decoration: BoxDecoration(
            color: style.color,
            border: style.border,
            borderRadius: style.radius,
          ),
        ),
      ),
    );
  }
}
