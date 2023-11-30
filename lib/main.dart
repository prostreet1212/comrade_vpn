import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';
import 'screens/home_screen.dart';


late Size mq;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await Pref.initializeHive();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const MyApp());
  });


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OpenVpn Demo',
      home: SplashScreen(),
      theme: ThemeData(useMaterial3: false,
      /*  buttonTheme: ButtonThemeData(
        ),*/
        appBarTheme: AppBarTheme(centerTitle: true,elevation: 3)
      ),
      darkTheme: ThemeData(useMaterial3: false,
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(centerTitle: true,elevation: 3),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.orange)
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}

extension AppTheme on ThemeData{
  Color get lightText=>Get.isDarkMode?Colors.white70:Colors.black54;
}


