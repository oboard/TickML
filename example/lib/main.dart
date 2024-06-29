import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/xcode.dart';
import 'package:highlight/languages/xml.dart';
import 'package:multi_split_view/multi_split_view.dart';

import 'package:tickml/tickml.dart';
import 'package:tickml_example/counter_sample.dart';

void main() {
  runApp(const TickMLApp());
}

class TickMLApp extends StatefulWidget {
  const TickMLApp({super.key});

  @override
  State<TickMLApp> createState() => _TickMLAppState();
}

class _TickMLAppState extends State<TickMLApp> {
  final MultiSplitViewController splitViewController =
      MultiSplitViewController();

  final codeController = CodeController(
    text: counterSample,
    language: xml,
  );

  Widget buildMenuBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                // Copy code to clipboard
                Clipboard.setData(ClipboardData(text: codeController.text));
              },
            ),
          ),
          // Examples
          PopupMenuButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.red.withOpacity(0.1),
              ),
            ),
            icon: const Text("Samples"),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "<text>Hello, World!</text>",
                child: Text("Hello, World!"),
              ),
              const PopupMenuItem(
                value: counterSample,
                child: Text("Counter Sample"),
              ),
            ],
            onSelected: (value) {
              codeController.text = value.toString();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget buildCodeEditor() {
    return Container(
      color: Colors.white,
      child: CodeTheme(
        data: CodeThemeData(styles: xcodeTheme),
        child: SingleChildScrollView(
          child: CodeField(
            controller: codeController,
            onChanged: (p0) {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Widget buildPreview() {
    return Center(
      child: TickML(codeController.text),
    );
  }

  @override
  void initState() {
    super.initState();
    splitViewController.areas = [
      Area(
        data: 'code',
        size: 600,
        min: 100,
      ),
      Area(data: 'preview', flex: 1),
    ];
    // _controller.addListener(_rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TickML Pad',
      home: Scaffold(
        body: MultiSplitViewTheme(
          data: MultiSplitViewThemeData(
            dividerPainter: DividerPainters.grooved1(),
          ),
          child: MultiSplitView(
            // onDividerDragUpdate: _onDividerDragUpdate,
            // onDividerTap: _onDividerTap,
            // onDividerDoubleTap: _onDividerDoubleTap,
            controller: splitViewController,
            // pushDividers: _pushDividers,
            builder: (BuildContext context, Area area) => area.data == 'code'
                ? Column(
                    children: [
                      buildMenuBar(),
                      Expanded(child: buildCodeEditor()),
                    ],
                  )
                : buildPreview(),
          ),
        ),
      ),
    );
  }
}
