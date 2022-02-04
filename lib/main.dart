import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/db/db_services.dart';
import 'package:to_do_app/screens/homepage.dart';
import 'package:to_do_app/screens/theme.dart';
import 'package:to_do_app/services/themeServices.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbServices.initDb();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeServices().theme,
        home: Homepage());
  }
}
