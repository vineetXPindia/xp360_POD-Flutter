import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/splash_screen/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? loggedIn = prefs.getBool('loggedIn');


  Widget initialScreen = SplashScreen(isLoggedIn: loggedIn,);
  runApp(MyApp(initialScreen: initialScreen,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialScreen});
  final Widget initialScreen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.blue.shade900, // Change the cursor color
            // Change the slider (handle) color
            selectionHandleColor: Colors.blue.shade900,
            selectionColor: Colors.orangeAccent.withAlpha((0.2*255).toInt()), // Highlight color for selected text
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: initialScreen,
        navigatorKey: navigatorKey
    );
  }
}
