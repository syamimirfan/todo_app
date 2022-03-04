import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';  //for GetMaterialApp
import 'package:to_do_apps/db/db_helper.dart';
import 'package:to_do_apps/services/theme_services.dart';
import 'package:to_do_apps/ui/home_page.dart';
import 'package:to_do_apps/ui/theme.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //initialization for GetStorage for changing theme
  await GetStorage.init();

  //for database
  await DBHelper.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: HomePage(),
    );
  }
}
