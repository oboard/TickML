import 'dart:async';

import 'package:flutter/material.dart';
import 'element.dart';

class RefreshContainer extends StatefulWidget {
  final TickElement element;
  final Widget child;
  final Duration duration;

  const RefreshContainer({
    required this.element,
    required this.duration,
    required this.child,
    super.key,
  });

  @override
  RefreshContainerState createState() => RefreshContainerState();
}

class RefreshContainerState extends State<RefreshContainer> {
  late Timer _timer;
  Widget? content;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (Timer timer) {
      // 刷新逻辑在这里实现
      // 利用Key强制child重新创建
      content = TickElement.parseNode(
              widget.element.selfElement!,
              widget.element.hetu!,
              widget.element.externalWidgets,
              widget.element.play)
          .build();
      // print(widget.element.attributes[':sweep']);
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: UniqueKey(),
      child: content ?? widget.child,
    );
  }
}
