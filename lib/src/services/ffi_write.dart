import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';

typedef _WriteNative = Int Function(Int, Pointer<Uint8>, Int);
typedef _WriteDart = int Function(int, Pointer<Uint8>, int);

typedef _OpenNative = Int Function(Pointer<Utf8>, Int);
typedef _OpenDart = int Function(Pointer<Utf8>, int);

typedef _CloseNative = Int Function(Int);
typedef _CloseDart = int Function(int);

typedef _IsattyNative = Int Function(Int);
typedef _IsattyDart = int Function(int);

/// Provides low-level terminal output via FFI calls to libc.
class FfiWrite {
  FfiWrite._() {
    _lib = _loadLib();
    _write = _lib.lookupFunction<_WriteNative, _WriteDart>('write');
    _open = _lib.lookupFunction<_OpenNative, _OpenDart>('open');
    _close = _lib.lookupFunction<_CloseNative, _CloseDart>('close');
    _isatty = _lib.lookupFunction<_IsattyNative, _IsattyDart>('isatty');
  }

  /// The singleton instance of [FfiWrite].
  static final FfiWrite instance = FfiWrite._();

  late final DynamicLibrary _lib;
  late final _WriteDart _write;
  late final _OpenDart _open;
  late final _CloseDart _close;
  late final _IsattyDart _isatty;

  int? _ttyFd;

  static DynamicLibrary _loadLib() {
    if (Platform.isLinux) return DynamicLibrary.open('libc.so.6');
    if (Platform.isMacOS) return DynamicLibrary.open('libc.dylib');
    throw UnsupportedError('FfiWrite: unsupported platform');
  }

  /// Opens `/dev/tty` for direct terminal output; returns the file descriptor or -1 on failure.
  int openTty() {
    if (_isatty(1) == 0) return -1;
    final path = '/dev/tty'.toNativeUtf8();
    try {
      final fd = _open(path, 1);
      if (fd < 0) return -1;
      _ttyFd = fd;
      return fd;
    } finally {
      malloc.free(path);
    }
  }

  /// Writes [data] as UTF-8 bytes to the terminal file descriptor.
  void writeString(String data) {
    final fd = _ttyFd ?? 1;
    final encoded = utf8.encode(data);
    final buf = malloc<Uint8>(encoded.length);
    for (int i = 0; i < encoded.length; i++) {
      buf[i] = encoded[i];
    }
    try {
      _write(fd, buf, encoded.length);
    } finally {
      malloc.free(buf);
    }
  }

  /// Closes the previously opened TTY file descriptor.
  void closeTty() {
    if (_ttyFd != null) {
      _close(_ttyFd!);
      _ttyFd = null;
    }
  }
}
