import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<int, Uint8List?> base64imageMap = {};

class ImagePicture extends StatelessWidget {
  final double? width, height;
  final String? url;
  final Uint8List? raw;
  final BoxFit fit;

  const ImagePicture(
      {super.key,
      this.url,
      this.fit = BoxFit.none,
      this.width,
      this.height,
      this.raw});

  @override
  Widget build(BuildContext context) {
    if (raw != null) {
      if (base64imageMap[raw!.length] == null) {
        base64imageMap[raw!.length] = raw;
      }
      return Image.memory(
        base64imageMap[raw!.length]!,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.medium,
      );
    }
    if (url == null || url!.isEmpty) return Container();
    if (url!.contains('data:image') && url!.contains('base64')) {
      if (base64imageMap[url!.length] == null) {
        base64imageMap[url!.length] =
            const Base64Decoder().convert(url!.split(',')[1]);
      }
      return Image.memory(
        base64imageMap[url!.length]!,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.medium,
      );
    }
    late ImageProvider imageProvider;
    if (url!.contains('images/')) {
      imageProvider = AssetImage(url!);
    } else if (url!.contains('http')) {
      return Image.network(
        url ?? '',
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.medium,
        cacheHeight: height?.toInt(),
        cacheWidth: width?.toInt(),
      );
    }
    return Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
