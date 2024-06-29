# TickML

TickML is a markup language for [flutter](https://flutter.dev/) and scripts powered by [Hetu Script](https://hetu.dev/).

![GitHub Stars](https://img.shields.io/github/stars/oboard/tickml?style=social)
![Pub Version](https://img.shields.io/pub/v/tickml)

![Counter Sample Screenshot](/screenshots/image.png)

## Usage

### Install

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  tickml: ^1.0.1
```

### Minimal Example

```dart
import 'package:flutter/material.dart';
import 'package:tickml/tickml.dart';

void main() {
  runApp(const TickMLApp());
}

class TickMLApp extends StatelessWidget {
  const TickMLApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
            child: TickML(
                '<text>Hello, World!</text>'
            ),
        ),
      ),
    );
  }
}
```

## Contributers

![Github Contributors](https://contrib.rocks/image?repo=oboard/tickml)
