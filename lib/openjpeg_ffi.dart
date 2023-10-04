import 'dart:ffi';
import 'dart:io';

import 'openjpeg_ffi_bindings_generated.dart';

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
int decode(
  Pointer<Uint8> data,
  int dataLength,
  Pointer<Pointer<Uint8>> outputData,
  Pointer<Uint32> width,
  Pointer<Uint32> height,
) =>
    _bindings.opj_plugin_decode(
      data,
      dataLength,
      outputData,
      width,
      height,
    );

/// A longer lived native function, which occupies the thread calling it.
///
/// Do not call these kind of native functions in the main isolate. They will
/// block Dart execution. This will cause dropped frames in Flutter applications.
/// Instead, call these native functions on a separate isolate.
///
/// Modify this to suit your own use case. Example use cases:
///
/// 1. Reuse a single isolate for various different kinds of requests.
/// 2. Use multiple helper isolates for parallel execution.

const String _libName = 'openjpeg_ffi';

/// The dynamic library in which the symbols for [OpenjpegFfiBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final OpenjpegFfiBindings _bindings = OpenjpegFfiBindings(_dylib);
