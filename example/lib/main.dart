import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:openjpeg_ffi/openjpeg_ffi.dart' as openjpeg_ffi;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int _result;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'result = $_result',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  void _initializeAsync() async {
    ByteData bytes = await rootBundle.load('assets/image.j2k');
    Uint8List imageData = bytes.buffer.asUint8List();
    final pointer = malloc.allocate<ffi.Uint8>(imageData.length);
    final outputData = calloc<ffi.Pointer<ffi.Uint8>>();

    final width = calloc<ffi.Uint32>();
    final height = calloc<ffi.Uint32>();
    for (int i = 0; i < imageData.length; i++) {
      pointer[i] = imageData[i];
    }
    _result = openjpeg_ffi.decode(
        pointer, imageData.length, outputData, width, height);
    malloc.free(pointer);
  }
}
