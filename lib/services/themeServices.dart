import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/http/io/file_decoder_io.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final _store = GetStorage();
  final _key = 'isdark';
  _saveTheme(bool isdark) => _store.write(_key, isdark);
  bool _loadTheme() => _store.read(_key) ?? false;
  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;
  void switchTheme() {
    Get.changeThemeMode(_loadTheme() ? ThemeMode.light : ThemeMode.dark);
    _saveTheme(!_loadTheme());
  }
}
 