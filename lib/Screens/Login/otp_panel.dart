import 'package:flutter/material.dart';
import '../../repository/login_impl.dart';
import '../Home/home_screen.dart';
import '../widgets/shared_widgets.dart';

class OtpPanel extends StatefulWidget {
  final String phoneNumber;
  const OtpPanel({super.key, required this.phoneNumber});

  @override
  State<OtpPanel> createState() => _OtpPanelState();
}

class _OtpPanelState extends State<OtpPanel> {

  LoginImpl login_impl = LoginImpl();

  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose(){
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes){
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('Enter otp to continue', style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),),
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return otpField(index);
          }),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              elevatedButtonWidget((){
                Navigator.of(context).pop();
              }, 'Cancel', Colors.red.shade700, Colors.white),
              elevatedButtonWidget(() async{
                String otp = _controllers.map((controller) => controller.text).join();
                bool result = await login_impl.validateOtp(widget.phoneNumber, otp);
                // if authentication success then show otp dialog

                if(result){
                  if(context.mounted){
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false, // Removes all previous routes
                    );
                  }
                }
              }, 'Submit', Colors.blue.shade900, Colors.white)
            ],
          ),
        ],
      ),
    );
  }

  Widget otpField(int index) {
    return SizedBox(
      height: 45,
      width: 40,
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
          onChanged: (value){
            if(value.isNotEmpty && index < 3){
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
            else if(value.isEmpty && index > 0){
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
          maxLength: 1,
          textAlign: TextAlign.center,
          decoration: otpDecoration(),
        ),
      ),
    );
  }
}
