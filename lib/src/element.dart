import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:hetu_script/hetu_script.dart';
import 'package:html/dom.dart' hide Text;
import 'attribute.dart';
import 'button.dart';
import 'clipper.dart';
import 'hex_color.dart';
import 'image_picture.dart';

import 'refresh_container.dart';

class TickElement {
  Hetu? hetu;
  Element? selfElement;

  String name = 'SizedBox';
  String text = '';
  bool play = true;

  Map<Object, dynamic> attributes = {};
  Map<String, Widget Function(TickElement)> externalWidgets = const {};
  // double? width, height;
  // Color? color;
  // double? size;
  // BoxShape? shape;
  // BoxFit? fit;
  // BorderRadius? borderRadius;
  // AlignmentGeometry alignment = AlignmentDirectional.topStart;
  // MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
  // CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
  // MainAxisSize mainAxisSize = MainAxisSize.max;
  // List<BoxShadow> shadows = [];
  // Clip? clipBehavior;

  Widget child = const SizedBox();
  List<Widget> children = [];

  TickElement? childElement;

  void setText(String value) {
    text = value;
  }

  void tryEval(String script) {
    // print(script);
    try {
      hetu?.eval(script);
    } on HTError catch (_, e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget build() {
    if (attributes['if']?.contains('false') ?? false) {
      return const SizedBox();
    }

    var externalWidget = externalWidgets[name.toLowerCase()];
    if (externalWidget != null) {
      return externalWidget(this);
    }

    switch (name.toLowerCase()) {
      case 'stack':
        return Stack(
          alignment: attributes['alignment'] ?? AlignmentDirectional.topStart,
          clipBehavior: attributes['clipbehavior'] ?? Clip.hardEdge,
          children: children,
        );
      case 'listview':
        return ListView(
          scrollDirection: attributes['direction'],
          clipBehavior: attributes['clipbehavior'] ?? Clip.hardEdge,
          children: children,
        );
      case 'html':
      case 'column':
      case 'div':
      case 'body':
        return Column(
          mainAxisAlignment:
              attributes['mainaxisalignment'] ?? MainAxisAlignment.start,
          mainAxisSize: attributes['mainaxissize'] ?? MainAxisSize.max,
          crossAxisAlignment:
              attributes['crossaxisalignment'] ?? CrossAxisAlignment.center,
          children: children,
        );
      case 'row':
        return Row(
          mainAxisAlignment:
              attributes['mainaxisalignment'] ?? MainAxisAlignment.start,
          mainAxisSize: attributes['mainaxissize'] ?? MainAxisSize.max,
          crossAxisAlignment:
              attributes['crossaxisalignment'] ?? CrossAxisAlignment.center,
          children: children,
        );
      case 'expanded':
        return Expanded(child: child);
      case 'flex':
        return Flex(
          direction: attributes['direction'] ?? Axis.horizontal,
          mainAxisAlignment:
              attributes['mainaxisalignment'] ?? MainAxisAlignment.center,
          crossAxisAlignment:
              attributes['crossaxisalignment'] ?? CrossAxisAlignment.center,
          mainAxisSize: attributes['mainaxissize'] ?? MainAxisSize.max,
          clipBehavior: attributes['clipbehavior'] ?? Clip.none,
          children: children,
        );
      case 'image':
      case 'img':
        return ImagePicture(
          url: text,
          width: attributes['width'],
          height: attributes['height'],
          fit: attributes['fit'] ?? BoxFit.contain,
        );
      case 'cliprect':
        return ClipRect(
          clipBehavior: attributes['clipbehavior'] ?? Clip.antiAlias,
          child: child,
        );
      case 'cliprrect':
        return ClipRRect(
          clipBehavior: attributes['clipbehavior'] ?? Clip.antiAlias,
          borderRadius: attributes['borderradius'] ?? BorderRadius.zero,
          child: child,
        );
      case 'blur':
        double x, y;
        if (attributes['radius'] != null) {
          x = y = attributes['radius'] ?? 0;
        } else {
          x = attributes['x'] ?? 0;
          y = attributes['y'] ?? 0;
        }
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: x,
            sigmaY: y,
          ),
          child: child,
        );
      case 'textfield':
        return const TextField();
      case 'padding':
        var all = attributes['all'];
        if (all != null) {
          return Padding(
            padding: EdgeInsets.all(all),
            child: child,
          );
        } else {
          List<double> p = [0, 0, 0, 0];
          p[0] = attributes['left'] ?? 0;
          p[1] = attributes['top'] ?? 0;
          p[2] = attributes['right'] ?? 0;
          p[3] = attributes['bottom'] ?? 0;
          return Padding(
            padding: EdgeInsets.fromLTRB(p[0], p[1], p[2], p[3]),
            child: child,
          );
        }
      case 'border':
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: attributes['color'] ?? Colors.black,
              width: attributes['width'] ?? 1.0,
            ),
            shape: attributes['shape'] ?? BoxShape.rectangle,
            borderRadius: attributes['borderradius'],
            boxShadow: attributes['shadows'],
          ),
          child: child,
        );
      case 'animation':
        if (!play) return child;
        if (childElement == null) return const SizedBox();
        return RefreshContainer(
          duration: Duration(milliseconds: attributes['duration'] ?? 0),
          element: childElement!,
          child: child,
        );
      case 'safe':
      case 'safearea':
        return SafeArea(
          child: child,
        );
      case 'opacity':
        var o = attributes['opacity'] ?? 1;
        if (o > 1) o = 1;
        if (o < 0) o = 0;
        return Opacity(
          opacity: o,
          child: child,
        );
      case 'spacer':
        return const Spacer();
      case 'gesturedetector':
      case 'gesture':
        return GestureDetector(
          onTap: () {
            tryEval(attributes['ontap'] ?? '');
          },
          onLongPress: () => tryEval(attributes['onlongpress'] ?? ''),
          // onPanDown: tryEval(extra['onPanDown'] ?? ''),
          // onPanUpdate: tryEval(extra['onPanUpdate'] ?? ''),
          // onPanStart: tryEval(extra['onPanStart'] ?? ''),
          // onPanEnd: tryEval(extra['onPanEnd'] ?? ''),
          child: child,
        );
      case 'arcclipper':
        return ClipPath(
          clipper: ArcClipper(double.tryParse(attributes['start'] ?? '0') ?? 0,
              double.tryParse(attributes['sweep'] ?? '0') ?? 0),
          clipBehavior: attributes['clipbehavior'] ?? Clip.antiAlias,
          child: child,
        );
      case 'rotate':
        Offset? origin;
        if (attributes['x'] != null || attributes['y'] != null) {
          origin = Offset(double.tryParse(attributes['x'] ?? '0') ?? 0,
              double.tryParse(attributes['y'] ?? '0') ?? 0);
        }
        return Transform.rotate(
          angle: (double.tryParse(attributes['angle'] ?? '0') ?? 0) *
              (math.pi / 180.0),
          origin: origin,
          alignment: attributes['alignment'] ?? Alignment.center,
          child: child,
        );
      case 'pos':
        return Positioned(
          top: attributes['top'],
          left: attributes['left'],
          right: attributes['right'],
          bottom: attributes['bottom'],
          width: attributes['width'],
          height: attributes['height'],
          child: child,
        );
      case 'offset':
      case 'translate':
        Offset offset = const Offset(0, 0);
        if (attributes['offsetx'] != null || attributes['offsety'] != null) {
          offset = Offset(double.tryParse(attributes['offsetx'] ?? '0') ?? 0,
              double.tryParse(attributes['offsety'] ?? '0') ?? 0);
        }
        return Transform.translate(
          offset: offset,
          child: child,
        );
      case 'scale':
        double? scaleX, scaleY, scale;
        Offset? origin;
        if (attributes['originx'] != null || attributes['originy'] != null) {
          origin = Offset(double.tryParse(attributes['originy'] ?? '0') ?? 0,
              double.tryParse(attributes['originy'] ?? '0') ?? 0);
        }
        if (attributes['x'] != null || attributes['y'] != null) {
          scaleX = double.tryParse(attributes['x'] ?? '1') ?? 1;
          scaleY = double.tryParse(attributes['y'] ?? '1') ?? 1;
        } else {
          scale = double.tryParse(attributes['scale'] ?? '1') ?? 1;
        }
        return Transform.scale(
          scaleX: scaleX,
          scaleY: scaleY,
          scale: scale,
          origin: origin,
          alignment: attributes['alignment'] ?? Alignment.center,
          child: child,
        );
      case 'button':
        return TickButton(
            onPressed: () {
              tryEval(attributes['onpressed'] ?? '');
              tryEval(attributes['ontap'] ?? '');
            },
            child: child);
      case 'fsizedbox':
      case 'fractionallysizedbox':
        return FractionallySizedBox(
          alignment: attributes['alignment'],
          widthFactor: attributes['width'],
          heightFactor: attributes['height'],
          child: child,
        );
      case 'sizedbox':
      case 'size':
        return SizedBox(
          width: attributes['width'],
          height: attributes['height'],
          child: child,
        );
      case 'align':
        return Align(
          alignment: attributes['alignment'],
          child: child,
        );
      case 'square':
        return SizedBox.square(
          dimension: double.tryParse(
                  attributes['dimension'] ?? attributes['size'] ?? '0') ??
              0,
          child: child,
        );
      case 'color':
        return Container(
          color: HexColor.fromHex(text),
          width: double.infinity,
          height: double.infinity,
        );
      case 'container':
      case 'box':
        return Container(
          decoration: BoxDecoration(
            shape: attributes['shape'] ?? BoxShape.rectangle,
            borderRadius: attributes['borderradius'],
            color: attributes['color'],
            boxShadow: attributes['shadows'],
          ),
          alignment: attributes['alignment'] ?? Alignment.center,
          width: attributes['width'],
          height: attributes['height'],
          child: child,
        );
      case 'a':
      case 'p':
      case 'text':
        return Text(
          text,
          maxLines: int.tryParse(attributes['maxlines'] ?? '1f'),
          style: TextStyle(
            color: attributes['color'],
            fontSize: attributes['size'] ?? attributes['font-size'],
            shadows: attributes['shadows'],
          ),
        );
    }
    return const SizedBox();
  }

  static TickElement parseNode(Element element, Hetu analyzeHetu,
      Map<String, Widget Function(TickElement)> externalWidgets, bool play) {
    TickElement e = TickElement();
    return analyze(e, element, analyzeHetu, externalWidgets, play);
  }

  static TickElement analyze(TickElement e, Element element, Hetu analyzeHetu,
      Map<String, Widget Function(TickElement)> externalWidgets, bool play) {
    e.externalWidgets = externalWidgets;
    e.selfElement = element.clone(true);
    e.hetu = analyzeHetu;
    e.play = play;
    List<MapEntry<Object, String>> extraAdd = [];
    try {
      element.attributes.forEach((key, value) {
        if ((key as String).startsWith(':')) {
          // analyzeHetu.eval(hetuHeaders);
          var v = analyzeHetu.eval(value).toString();
          extraAdd.add(MapEntry(key.substring(1), v));
        }
      });
    } on HTError catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    element.attributes.addEntries(extraAdd);
    // print(element.attributes);

    e.name = (element.localName ?? 'SizedBox').trim();
    e.text = (element.text.trim().isEmpty)
        ? element.attributes['value'] ?? element.attributes['content'] ?? ''
        : element.text;

    // e.attributes = element.attributes.map(
    //     (key, value) => MapEntry(key.toString().trim().toLowerCase(), value));

    e.attributes = getAttributeMap(element.attributes);

    if (element.children.isNotEmpty) {
      if (!((element.localName ?? '').startsWith('script'))) {
        final ele = e.childElement = TickElement.parseNode(
            element.children.first, analyzeHetu, externalWidgets, play);
        e.child = ele.build();
      }
      e.children = element.children.map((child) {
        if ((child.localName ?? '').startsWith('script')) {
          try {
            analyzeHetu.eval(element.text);
          } on HTError catch (_, e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
        return TickElement.parseNode(child, analyzeHetu, externalWidgets, play)
            .build();
      }).toList();
    }
    return e;
  }
}

class RefreshingWidget extends StatefulWidget {
  final int duration;
  final Widget child;
  final TickElement element;

  const RefreshingWidget({
    super.key,
    required this.duration,
    required this.child,
    required this.element,
  });

  @override
  RefreshingWidgetState createState() => RefreshingWidgetState();
}

class RefreshingWidgetState extends State<RefreshingWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
