import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/login_page.dart';
import '../scan_upload_pod/scanner_page.dart';
import '../widgets/shared_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String home_text = 'Tap the scan barcode button to scan XPCN barcode for uploading POD(s)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.only(right: 20),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image(image: AssetImage('assets/xp_logo_square.png')),
        ),

        actions: [
          elevatedButtonWidget((){
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    heightSpacer(),
                    heightSpacer(),
                    Text('Are you sure you want to logout?', style: TextStyle(fontSize: 16),),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      elevatedButtonWidget((){Navigator.of(context).pop();}, 'No', Colors.red.shade700, Colors.white),
                      elevatedButtonWidget(() async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove('loggedIn');
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,);
                      }, 'Yes', Colors.blue.shade900, Colors.white)
                    ],
                    // confirmation for logging out of the application

                  ),
                ],
              );
            });
          }, 'Logout', Colors.red.shade700, Colors.white)
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image(image: AssetImage('assets/removed_bg.png'), fit: BoxFit.cover,),
            Lottie.asset('assets/home_screen_animation.json'),
            Text(
              home_text,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18),
            ),
            SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // color: Colors.blue.withAlpha(20),
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        child: elevatedButtonWidget((){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScannerPage()));
        }, 'Scan XPCN Barcode', Colors.blue.shade900, Colors.white),
      ),
    );
  }
}
