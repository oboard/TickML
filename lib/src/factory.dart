import 'package:flutter/material.dart' hide Element;
import 'package:flutter/services.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:html/parser.dart' show parse;
import 'element.dart';

int renderId = 0;

String hetuHeaders = '';

class TickML extends StatelessWidget {
  const TickML(this.src,
      {super.key,
      this.externalFunctions = const {},
      this.externalWidgets = const {},
      this.play = true});

  final String src;
  final Map<String, Function> externalFunctions;
  final Map<String, Widget Function(TickElement)> externalWidgets;
  final bool play;

  @override
  Widget build(BuildContext context) {
    final Hetu hetu =
        Hetu(config: HetuConfig(printPerformanceStatistics: false));

    Map<String, Function> internelFunctions = {
      'argb': (HTEntity entity,
              {List<dynamic> positionalArgs = const [],
              Map<String, dynamic> namedArgs = const {},
              List<HTType> typeArgs = const []}) =>
          Color.fromARGB(
            positionalArgs[0],
            positionalArgs[1],
            positionalArgs[2],
            positionalArgs[3],
          ).value.toString(),
      'rgbo': (HTEntity entity,
              {List<dynamic> positionalArgs = const [],
              Map<String, dynamic> namedArgs = const {},
              List<HTType> typeArgs = const []}) =>
          Color.fromRGBO(
            positionalArgs[0],
            positionalArgs[1],
            positionalArgs[2],
            positionalArgs[3],
          ).value,
      'delay': (HTEntity entity,
              {List<dynamic> positionalArgs = const [],
              Map<String, dynamic> namedArgs = const {},
              List<HTType> typeArgs = const []}) =>
          Future.delayed(Duration(seconds: positionalArgs[0]), () {}),
      'haptic': (HTEntity entity,
          {List<dynamic> positionalArgs = const [],
          Map<String, dynamic> namedArgs = const {},
          List<HTType> typeArgs = const []}) {
        // vibrate ≈ lightImpact > mediumImpact > heavyImpact > selectionClick
        if (positionalArgs.isNotEmpty) {
          switch (positionalArgs[0]) {
            case 0:
              HapticFeedback.vibrate();
              break;
            case 1:
              HapticFeedback.lightImpact();
              break;
            case 2:
              HapticFeedback.mediumImpact();
              break;
            case 3:
              HapticFeedback.heavyImpact();
              break;
          }
        }
      },

      // 'hello': (HTEntity entity,
      //         {List<dynamic> positionalArgs = const [],
      //         Map<String, dynamic> namedArgs = const {},
      //         List<HTType> typeArgs = const []}) =>
      //     {'greeting': 'Hello from Dart!'},
    };

    hetu.init(externalFunctions: {
      ...internelFunctions,
      ...externalFunctions,
    });
    // var hetuValue = hetu.eval(r'''
    //   external fun hello
    //   var dartValue = hello()
    //   dartValue['reply'] = 'Hi, this is Hetu.'
    //   dartValue // the script will return the value of it's last expression
    //   ''');
    // print('hetu value: $hetuValue');

    hetuHeaders = '';
    internelFunctions.forEach((key, value) {
      hetuHeaders += 'external fun $key\n';
    });
    externalFunctions.forEach((key, value) {
      hetuHeaders += 'external fun $key\n';
    });
    hetu.eval(hetuHeaders);

    // hetu.eval('var state = 0');
    // hetu.eval('print(state)');
    renderId = 0;
    var document = parse(src);
    // print(document);
    // print(document.firstChild!.children.first);
    // print(document.children.last);
    // print(document.children.first.children.first);
    // return Container();
    var widgets = externalWidgets
        .map((key, value) => MapEntry(key.trim().toLowerCase(), value));
    if (document.children.last.children.last.children.isEmpty) {
      return Container();
    }
    return TickElement.parseNode(
            document.children.last.children.last.children.last,
            hetu,
            widgets,
            play)
        .build();
  }
}
