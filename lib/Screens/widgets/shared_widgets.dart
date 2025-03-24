import 'package:flutter/material.dart';
InputDecoration inputDecoration(String label, IconData? icon, {TextStyle? labelStyle}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    suffixIcon: Padding(
      padding: EdgeInsets.only(right: 10),
      child: Icon(icon, color: Colors.grey.shade600,),
    ),
    labelText: label,
    labelStyle: labelStyle ?? TextStyle(
      color: Colors.grey.shade600,
    ),
  );
}

InputDecoration otpDecoration() {
  return InputDecoration(
    counterText: '',
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  );
}

Widget elevatedButtonWidget(Function() navigationFunction, String? buttonText, Color backgroundColor, Color foregroundColor, {Icon? icon}) {
  return ElevatedButton(
    style: ButtonStyle(
        iconAlignment: IconAlignment.start,
        overlayColor: WidgetStatePropertyAll(Colors.white.withAlpha((0.3*255).toInt()),),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
        elevation: WidgetStatePropertyAll(4)
    ),
    onPressed: () {
      navigationFunction();
    },
    child: Text(buttonText ?? ''),
  );
}

Widget heightSpacer({double? height}){
  return SizedBox(height: height ?? 20,);
}

Widget widthSpacer({double? width}){
  return SizedBox(
    width: width ?? 20,
  );
}

Theme datePickerTheme(Widget? child){
  return Theme(
    data: ThemeData(
      colorScheme: ColorScheme.light(
        primary: Colors.blue.shade900, // ✅ Header background & selected date color
        onPrimary: Colors.white, // ✅ Header text color
        onSurface: Colors.black, // ✅ Text color
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue.shade900, // ✅ Button text color
        ),
      ),
    ),
    child: child!,
  );
}

Theme timePickerTheme(Widget? child) {
  return Theme(
    data: ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.blue.shade900, // ✅ Header & selected time color
        onPrimary: Colors.white, // ✅ Header text color
        onSurface: Colors.black, // ✅ Default text color
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.white, // ✅ Dialog background color
        hourMinuteColor: Colors.grey.shade100,
        hourMinuteTextColor: Colors.black,
        dialHandColor: Colors.blue.shade900, // ✅ Dial hand color
        dialBackgroundColor: Colors.grey.shade100, // ✅ Dial background
        dialTextColor: WidgetStateColor.resolveWith((states) =>
        states.contains(WidgetState.selected) ? Colors.white : Colors.black), // ✅ Dial numbers

        dayPeriodColor: Colors.blue.shade900.withAlpha((0.2*255).toInt()), // ✅ AM/PM selector background
        dayPeriodTextColor: Colors.black, // ✅ AM/PM selector text

        entryModeIconColor: Colors.blue.shade900, // ✅ Keyboard icon color
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue.shade900, // ✅ Button text color
        ),
      ),
    ),
    child: child!,
  );
}

Widget infoRow(
    double screenWidth, double screenHeight, String label, String value, {TextStyle? valueStyle}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.black.withAlpha((0.5*255).toInt()),
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: screenWidth * 0.02,
        ),
        Flexible(
            child: Text(
              value,
              style: valueStyle ?? TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12,),
            )),
      ],
    ),
  );
}

