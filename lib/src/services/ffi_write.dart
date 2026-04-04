import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';

typedef _WriteNative = Int Function(Int, Pointer<Uint8>, Int);
typedef _WriteDart = int Function(int, Pointer<Uint8>, int);

typedef _OpenNative = Int Function(Pointer<Utf8>, Int);
typedef _OpenDart = int Function(Pointer<Utf8>, int);

typedef _CloseNative = Int Function(Int);
typedef _CloseDart = int Function(int);

class FfiWrite {
  FfiWrite._() {
    _lib = _loadLib();
    _write = _lib.lookupFunction<_WriteNative, _WriteDart>('write');
    _open = _lib.lookupFunction<_OpenNative, _OpenDart>('open');
    _close = _lib.lookupFunction<_CloseNative, _CloseDart>('close');
  }

  static final FfiWrite instance = FfiWrite._();

  late final DynamicLibrary _lib;
  late final _WriteDart _write;
  late final _OpenDart _open;
  late final _CloseDart _close;

  int? _ttyFd;

  static DynamicLibrary _loadLib() {
    if (Platform.isLinux) return DynamicLibrary.open('libc.so.6');
    if (Platform.isMacOS) return DynamicLibrary.open('libc.dylib');
    throw UnsupportedError('FfiWrite: unsupported platform');
  }

  int openTty() {
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

  void writeString(String data) {
    final fd = _ttyFd ?? 1;
    final units = data.codeUnits;
    final buf = malloc<Uint8>(units.length);
    for (int i = 0; i < units.length; i++) {
      buf[i] = units[i];
    }
    try {
      _write(fd, buf, units.length);
    } finally {
      malloc.free(buf);
    }
  }

  void closeTty() {
    if (_ttyFd != null) {
      _close(_ttyFd!);
      _ttyFd = null;
    }
  }
}
