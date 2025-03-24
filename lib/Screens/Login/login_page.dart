import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../repository/login_impl.dart';
import '../widgets/shared_widgets.dart';
import 'otp_panel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _textVisible = false;
  TextEditingController phoneNumberController = TextEditingController();

  LoginImpl login_impl = LoginImpl();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _textVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/unsplash_transport_image.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(190),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Image(
                          image: AssetImage('assets/xp_logo_square.png'),
                          height: 50,
                        ),

                        heightSpacer(),

                        AnimatedOpacity(
                          opacity: _textVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 800),
                          child: Text(
                            'Enter your mobile number to receive verification code',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                        ),

                        heightSpacer(),

                        TextField(
                          controller: phoneNumberController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // Allows only digits
                              LengthLimitingTextInputFormatter(10), // Limits input to 10 characters
                            ],
                          style: TextStyle(fontSize: 14),
                          decoration: inputDecoration('Phone Number', Icons.phone_rounded, labelStyle: TextStyle(fontSize: 14, color: Colors.black54))
                        ),

                        heightSpacer(),

                        elevatedButtonWidget(() async{
                          bool result = false;
                          if(phoneNumberController.text.length == 10){
                            result = await login_impl.requestOtp(phoneNumberController.text);
                          }
                          else{
                            Fluttertoast.showToast(msg: 'Invalid Phone Number', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
                          }
                          if(result){
                            if(context.mounted){
                              showDialog(
                                  barrierDismissible: false,
                                  barrierColor: Colors.black87,
                                  context: context, builder: (BuildContext context){
                                return OtpPanel(phoneNumber: phoneNumberController.text,);
                              });
                            }
                          }
                        }, 'Send OTP', Colors.blue.shade900, Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future presentView() {
  //   return showModalBottomSheet(
  //     isDismissible: false,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(0)
  //     ),
  //     context: context,
  //     isScrollControlled: true, // Allows full-screen height if needed
  //     backgroundColor: Colors.transparent, // Transparent background
  //     builder: (context) {
  //       return OtpPanel();
  //     },
  //   );
  // }
}
