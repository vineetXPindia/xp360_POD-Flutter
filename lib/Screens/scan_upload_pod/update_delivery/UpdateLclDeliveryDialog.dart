import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../repository/pod_upload_impl.dart';
import '../../widgets/shared_widgets.dart';

class UpdateDeliveryLCLDialog extends StatefulWidget {
  final int? intOrderId;
  final String? orderId, customerName;
  final DateTime? minDate;
  final String? xpcnId;
  final String? xpcnNum;
  const UpdateDeliveryLCLDialog({super.key, this.intOrderId, this.orderId, this.customerName, this.minDate, required this.xpcnId, required this.xpcnNum});

  @override
  State<UpdateDeliveryLCLDialog> createState() => _UpdateDeliveryLCLDialogState();
}

class _UpdateDeliveryLCLDialogState extends State<UpdateDeliveryLCLDialog> {

  PodUploadImpl pod_upload_impl = PodUploadImpl();

  final TextEditingController _dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController xpcnController = TextEditingController();
  TextEditingController orderIdController = TextEditingController();

  Uri? extractImageUri(String scannedDocString) {
    String scannedDocuments = scannedDocString;
    String? imageUri;

    // Use regex to extract the imageUri
    RegExp regExp = RegExp(r'imageUri=(.*?)\]');
    Match? match = regExp.firstMatch(scannedDocuments);

    if (match != null) {
      imageUri = match.group(1)!;
      print("Extracted imageUri: $imageUri");
    } else {
      print("No imageUri found.");
    }

    return Uri.parse(imageUri!); // Return the extracted URI
  }

  Future<bool> updateDelivery(String? date, String? time) async{
    bool isDone = false;
    try{
      bool updated = await pod_upload_impl.updateDelivery(widget.intOrderId, date, time);
      setState(() {
        isDone = updated;
      });
      return isDone;
    }
    catch(e){
      throw Exception(e);
    }
  }

  Future<void> scanDocument(String? xpcnCode) async {
    try {
      final scannedData = await FlutterDocScanner().getScannedDocumentAsImages(page: 1);
      if (scannedData == null || scannedData.isEmpty) {
        debugPrint('Scanning failed: No document captured');
        return;
      }
      debugPrint('scanned result ==> ${scannedData.toString()}');

      String path = extractImageUri(scannedData.toString())!.path;
      path = path.replaceAll('%7D', '');

      File convertedFile = File(path);
      await pod_upload_impl.uploadPodLcl(convertedFile, widget.xpcnId, xpcnCode);
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Unexpected error: $e');
    }
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text('Update Delivery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 280, height: 20),
          infoRow(screenWidth, screenHeight, 'Order Id', '${widget.orderId}'),
          heightSpacer(),
          infoRow(screenWidth, screenHeight, 'XPCN', '${widget.xpcnNum}'),
          heightSpacer(),
          heightSpacer(),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              selectDate(context);
            },
            child: AbsorbPointer(
              child: TextField(
                  controller: _dateController,
                  decoration: inputDecoration(
                      'Select Date', Icons.calendar_today_rounded)),
            ),
          ),
          heightSpacer(),
          TextField(
            controller: timeController,
            readOnly: true,
            onTap: () async {
              TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child){
                    return timePickerTheme(child);
                  }
              );
              final nowDateTime = DateTime.now();
              if (time != null) {
                setState(() {
                  selectedTime = time;
                });
              }
              if (selectedDate != null) {
                DateTime combinedDateTime = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );
                if (combinedDateTime.isAfter(nowDateTime)) {
                  Fluttertoast.showToast(msg: 'select a time earlier than the current time', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
                  return;
                }
                else{
                  setState(() {
                    timeController.text = DateFormat("HH:mm").format(combinedDateTime);
                  });
                }

              }
            },
            decoration: inputDecoration('Select Time', Icons.watch_later_outlined),
          ),
        ],
      ),
      actions: [
        elevatedButtonWidget((){
          Navigator.of(context).pop();
        }, 'Cancel', Colors.red.shade700, Colors.white),
        elevatedButtonWidget(() async{
          if(selectedDate == null || selectedTime == null){
            Fluttertoast.showToast(msg: 'Please select date and time', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
          }
          else{
            bool isUpdated = await updateDelivery(DateFormat("yyyy-MM-dd").format(selectedDate!), timeController.text);
            if(context.mounted){
              Navigator.of(context).pop();
            }
            if(isUpdated == true){
              scanDocument(widget.xpcnNum);
            }
          }
        }, 'Update', Colors.blue.shade900, Colors.white),
      ],
    );
  }

  void closeDialog(){
    Navigator.of(context).pop();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        lastDate: DateTime.now(),
        firstDate: widget.minDate ?? DateTime(2024, 1),
        builder: (BuildContext context, Widget? child){
          return datePickerTheme(child);
        }
    );
    setState(() {
      selectedDate = picked;
      _dateController.text = DateFormat("yyyy-MM-dd").format(selectedDate!);
    });
  }
}
