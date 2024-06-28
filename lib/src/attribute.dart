import 'package:flutter/material.dart' hide Element;

import 'hex_color.dart';

Map<Object, dynamic> getAttributeMap(Map<Object, String> map) {
  // final map = element.attributes;
  Map<Object, dynamic> result = {};
  for (var key in map.keys) {
    var v = map[key];
    if (v == null) continue;

    String k = key.toString().trim().toLowerCase();
    result[k] = getAttribute(k, v);
  }

  return result;
}

dynamic getAttribute(key, v) {
  dynamic a;
  switch (key) {
    case 'class':
      a = v.split(' ');
      break;
    case 'duration':
    case 'delay':
      a = int.tryParse(v);
      break;
    case 'size':
    case 'radius':
    case 'alpha':
    case 'opacity':
    case 'x':
    case 'y':
    case 'all':
    case 'font-size':
    case 'top':
    case 'left':
    case 'right':
    case 'bottom':
    case 'width':
    case 'height':
      a = double.tryParse(v);
      break;
    case 'color':
      a = HexColor.fromHex(v);
      break;
    case 'borderradius':
      if (v.contains(',')) {
        List<String> every = v.split(',');
        List<double> everyCircular =
            every.map((e) => double.tryParse(e) ?? 0).toList();
        List<Radius> everyRadius =
            everyCircular.map((e) => Radius.circular(e)).toList();
        a = BorderRadius.only(
          topLeft: everyRadius[0],
          topRight: everyRadius[1],
          bottomLeft: everyRadius[2],
          bottomRight: everyRadius[3],
        );
      } else {
        a = BorderRadius.circular(double.tryParse(v) ?? 0);
      }
      break;
    case 'alignment':
      a = {
        'topLeft': Alignment.topLeft,
        'topCenter': Alignment.topCenter,
        'topRight': Alignment.topRight,
        'centerLeft': Alignment.centerLeft,
        'center': Alignment.center,
        'centerRight': Alignment.centerRight,
        'bottomLeft': Alignment.bottomLeft,
        'bottomCenter': Alignment.bottomCenter,
        'bottomRight': Alignment.bottomRight,
      }[v];

      break;
    case 'mainaxisalignment':
      a = {
        'start': MainAxisAlignment.start,
        'end': MainAxisAlignment.end,
        'center': MainAxisAlignment.center,
        'spaceBetween': MainAxisAlignment.spaceBetween,
        'spaceAround': MainAxisAlignment.spaceAround,
        'spaceEvenly': MainAxisAlignment.spaceEvenly,
      }[v];

      break;
    case 'crossaxisalignment':
      a = {
        'start': CrossAxisAlignment.start,
        'end': CrossAxisAlignment.end,
        'center': CrossAxisAlignment.center,
        'stretch': CrossAxisAlignment.stretch,
        'baseline': CrossAxisAlignment.baseline,
      }[v];

      break;
    case 'direction':
      a = {
        'vertical': Axis.vertical,
        'horizontal': Axis.horizontal,
      }[v];
      break;
    case 'shadows':
      List<BoxShadow> result = [];
      BoxShadow parseShadow(String s) {
        var ss = s.split(' ');
        return BoxShadow(
          color: HexColor.fromHex(ss[0]),
          blurRadius: double.tryParse(ss[1]) ?? 0,
          offset:
              Offset(double.tryParse(ss[2]) ?? 0, double.tryParse(ss[3]) ?? 0),
        );
      }
      if (v.toString().contains(',')) {
        var ss = v.toString().split(',');
        for (String s in ss) {
          result.add(parseShadow(s));
        }
      } else {
        result.add(parseShadow(v));
      }
      a = result;
      break;
    case 'shape':
      a = {
        'circle': BoxShape.circle,
        'rectangle': BoxShape.rectangle,
      }[v];
      break;
    case 'clipbehavior':
      a = {
        'none': Clip.none,
        'hardEdge': Clip.hardEdge,
        'antiAlias': Clip.antiAlias,
        'antiAliasWithSaveLayer': Clip.antiAliasWithSaveLayer,
      }[v];
      break;
    case 'textalign':
      a = {
        'left': TextAlign.left,
        'right': TextAlign.right,
        'center': TextAlign.center,
        'justify': TextAlign.justify,
        'start': TextAlign.start,
        'end': TextAlign.end,
      }[v];
      break;
    case 'fit':
      a = {
        'fill': BoxFit.fill,
        'contain': BoxFit.contain,
        'cover': BoxFit.cover,
        'fitWidth': BoxFit.fitWidth,
        'fitHeight': BoxFit.fitHeight,
        'none': BoxFit.none,
        'scaleDown': BoxFit.scaleDown,
      }[v];
      break;
    case 'weight':
      a = {
        'bold': FontWeight.bold,
        'normal': FontWeight.normal,
        'w100': FontWeight.w100,
        'w200': FontWeight.w200,
        'w300': FontWeight.w300,
        'w400': FontWeight.w400,
        'w500': FontWeight.w500,
        'w600': FontWeight.w600,
        'w700': FontWeight.w700,
        'w800': FontWeight.w800,
        'w900': FontWeight.w900,
      }[v];
      break;
    case 'content':
    case 'text':
    case 'value':
    default:
      a = v;
  }

  return a;
}
