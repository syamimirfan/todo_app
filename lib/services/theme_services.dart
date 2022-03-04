import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

//THIS IS TO CHANGE THE LIGHT MODE
//using
//get_storage:
//   get:
//in pubspec.yaml in dependencies
class ThemeService {
    final _box = GetStorage();
    final _key = 'isDarkMode';

    _saveThemeToBox(bool isDarkMode)=>_box.write(_key,isDarkMode);

    //if there is value then its return true, otherwise its return false
    bool _loadThemeFromBox() => _box.read(_key)??false;
    ThemeMode get theme=> _loadThemeFromBox()?ThemeMode.dark:ThemeMode.light;

    void switchTheme(){
        Get.changeThemeMode(_loadThemeFromBox()?ThemeMode.light:ThemeMode.dark);
        _saveThemeToBox(!_loadThemeFromBox()); //send _saveThemeToBox() as true to change back to light mode
    }
}