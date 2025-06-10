This is a simple customizable slider.

## Features

* It slides based on the range you registered

## Usage

Here's a basic usage example
```dart
Container(
    height: 5, // Must set a value higher than one
    child: TSlider(
        onDragged: (value) {
            setState(() {
                myValue = value;
            });
        },
        background: TSliderTrackStyle(
            color: Colors.white
        ),
        primary: TSliderConfiguration(
            value: myValue,
            range: TRange(min: 0, max: 1), // The values will range from 0 to 1 (percentage)
            // range: TRange(min: 40, max: 60), // Values range from 40 to 60
            trackStyle: TSliderTrackStyle(
                color: Colors.black,
            ),
        ),
    ),
);
```

## Additional information

If you want to contribute, or just point out and error, visit the github repo: https://github.com/tonsoo/t-slider
