import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:xp360pod/Screens/scan_upload_pod/update_delivery/UpdateLclDeliveryDialog.dart';
import '../../model/lcl_xpcn_status_model.dart';
import '../../repository/pod_upload_impl.dart';
import '../widgets/shared_widgets.dart';


class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  bool isLoading = false;
  PodUploadImpl pod_upload_impl = PodUploadImpl();
  LclXpcnStatusModel? lclXpcnStatusModel;
  String? xpcnId;
  bool isFcl = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> fetchPodStatus(String? xpcnCode, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await scannerController.stop();
    presentView();

    String? result = await pod_upload_impl.getXpcnDetails(xpcnCode);
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (result == 'FCL') {
      setState(() {
        isFcl = true;
      });
      Map<String, dynamic> status = await pod_upload_impl.getFclXpcnStatus(xpcnCode);
      xpcnId = status.values.first.toString();
      if (status.keys.first == "1") {
        scanDocument(xpcnCode);
      }
      else if (status.keys.first == "0") {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('POD Exists!'),
                content: Text('POD already uploaded, Do you want to update the existing POD?'),
                actions: [
                  elevatedButtonWidget(
                        () async{
                      Navigator.of(dialogContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                      await scannerController.start();
                    },
                    'No',
                    Colors.red.shade700,
                    Colors.white,
                  ),
                  elevatedButtonWidget(
                        () {
                      Navigator.of(dialogContext).pop(); // Ensure the dialog closes completely
                      scanDocument(xpcnCode);
                    },
                    'Yes',
                    Colors.blue.shade900,
                    Colors.white,
                  ),
                ],
              );
            },
          );
        }
      }
      else if (status.keys.first == "2") {
        Fluttertoast.showToast(msg: 'Please validate delivery first!', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
        setState(() {
          isLoading = false;
        });
        await scannerController.start();
      }
    }
    else if(result == 'LCL'){
      setState(() {
        isFcl = false;
      });
      lclXpcnStatusModel = await pod_upload_impl.getLclXpcnStatus(xpcnCode);
      final data = lclXpcnStatusModel?.data;
      int? intOrderId = data?.intOrderId;
      String? orderId = data?.vcOrderId;
      xpcnId = data?.intXpcnId.toString();
      if(data?.intXpcnStatus == -1){
        Fluttertoast.showToast(msg: 'No records found for this XPCN', textColor: Colors.white, backgroundColor: Colors.red.shade800);
        await scannerController.start();
      }
      else if (data?.intXpcnStatus == 0) {
        Fluttertoast.showToast(msg: 'Shipment In Transit', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
        await scannerController.start();
      }
      else if (data?.intXpcnStatus == 1) {
        if(context.mounted){
          showDialog(context: context, builder: (BuildContext updateDeliveryContext){
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Update Delivery!'),
              content: Text('Order is out for delivery, kindly update to upload POD.'),
              actions: [
                elevatedButtonWidget((){Navigator.of(updateDeliveryContext).pop(); setState(() {
                  isLoading = false;
                });}, 'Cancel', Colors.red.shade700, Colors.white),
                elevatedButtonWidget((){
                  Navigator.of(updateDeliveryContext).pop();
                  showDialog(context: context, builder: (BuildContext updateDialog){
                    return UpdateDeliveryLCLDialog(orderId: orderId, intOrderId: intOrderId,xpcnId: xpcnId, xpcnNum: xpcnCode);
                  });
                  // commented code for
                }, 'Update', Colors.blue.shade900, Colors.white),
              ],
            );
          });
        }
      }
      else if(data?.intXpcnStatus == 2){
        Fluttertoast.showToast(msg: 'Opening Camera', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
        setState(() {
          isLoading = false;
        });
        scanDocument(xpcnCode);
      }
      else if (data?.intXpcnStatus == 3) {
        Fluttertoast.showToast(msg: 'POD Already Uploaded', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
        setState(() {
          isLoading = false;
        });
        await scannerController.start();
      }
      else if(data?.intXpcnStatus == 4){
        if(data?.arrivalPoint == 1){
          if(data?.dtVia1Arrival != null){
            var minDate = data?.dtVia1Arrival;
            if(context.mounted){
              showDialog(context: context, builder: (BuildContext updateDialogContext){
                return AlertDialog(
                  title: Text('Out for Delivery!'),
                  content: Text('Kindly update delivery to upload POD.'),
                  actions: [
                    elevatedButtonWidget((){
                      Navigator.of(updateDialogContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }, 'Cancel', Colors.red.shade700, Colors.white),
                    elevatedButtonWidget((){
                      Navigator.of(updateDialogContext).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateDeliveryLCLDialog(
                              intOrderId: intOrderId,
                              orderId: orderId,
                              minDate: minDate,
                              xpcnId: xpcnId,
                              xpcnNum: xpcnCode,
                            );
                          });
                    }, 'Update', Colors.blue.shade900, Colors.white),
                  ],
                );
              });
            }
          }
          else{
            Fluttertoast.showToast(msg: 'Update arrival at Via-1', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
        }
        else if(data?.arrivalPoint == 2){
          if(data?.dtVia2Arrival != null){
            var minDate = data?.dtVia2Arrival;
            if(context.mounted){
              showDialog(context: context, builder: (BuildContext updateContext){
                return AlertDialog(
                  title: Text('Out for Delivery'),
                  content: Text('Kindly update delivery to upload POD.'),
                  actions: [
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }, 'Cancel', Colors.red.shade700, Colors.white),
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateDeliveryLCLDialog(
                              intOrderId: intOrderId,
                              orderId: orderId,
                              minDate: minDate,
                              xpcnId: xpcnId,
                              xpcnNum: xpcnCode,);
                          });
                    }, 'Update', Colors.blue.shade900, Colors.white),
                  ],
                );
              });
            }
          }
          else{
            Fluttertoast.showToast(msg: 'Update arrival at Via-2', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
        }
        else if(data?.arrivalPoint == 3){
          if(data?.dtDestinationArrival != null){
            var minDate = data?.dtDestinationArrival;
            if(context.mounted){
              showDialog(context: context, builder: (BuildContext updateContext){
                return AlertDialog(
                  title: Text('Out for Delivery'),
                  content: Text('Kindly update delivery to upload POD.'),
                  actions: [
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }, 'Cancel', Colors.red.shade700, Colors.white),
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateDeliveryLCLDialog(
                              intOrderId: intOrderId,
                              orderId: orderId,
                              minDate: minDate,xpcnId: xpcnId,
                              xpcnNum: xpcnCode,);
                          });
                    }, 'Update', Colors.blue.shade900, Colors.white),
                  ],
                );
              });
            }
          }
          else{
            Fluttertoast.showToast(msg: 'Update arrival at Destination', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
        }
      }
      else if(data?.intXpcnStatus == 5){
        if(data?.dtDestinationArrival != null){
          var minDate = data?.dtDestinationArrival;
          if(context.mounted){
            showDialog(context: context, builder: (BuildContext updateContext){
              return AlertDialog(
                title: Text('Out for Delivery'),
                content: Text('Kindly update delivery to upload POD.'),
                actions: [
                  elevatedButtonWidget((){
                    Navigator.of(updateContext).pop();
                    setState(() {
                      isLoading = false;
                    });
                  }, 'Cancel', Colors.red.shade700, Colors.white),
                  elevatedButtonWidget((){
                    Navigator.of(updateContext).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UpdateDeliveryLCLDialog(
                            intOrderId: intOrderId,
                            orderId: orderId,
                            minDate: minDate,xpcnId: xpcnId,
                            xpcnNum: xpcnCode,);
                        });
                  }, 'Update', Colors.blue.shade900, Colors.white),
                ],
              );
            });
          }
        }
        else{
          Fluttertoast.showToast(msg: 'Update arrival at Destination', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
          setState(() {
            isLoading = false;
          });
          await scannerController.start();
        }
      }
      else if(data?.intXpcnStatus == 6){
        if(data?.arrivalPoint == 1){
          if(data?.originDepartedDate != null){
            var minDate = data?.originDepartedDate;
            if(context.mounted){
              showDialog(context: context, builder: (BuildContext updateContext){
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('Out for Delivery!'),
                  content: Text('Kindly update delivery to upload POD.'),
                  actions: [
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }, 'Cancel', Colors.red.shade700, Colors.white),
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateDeliveryLCLDialog(
                              intOrderId: intOrderId,
                              orderId: orderId,
                              minDate: minDate,xpcnId: xpcnId,
                              xpcnNum: xpcnCode,);
                          });
                    }, 'Update', Colors.blue.shade900, Colors.white),
                  ],
                );
              });
            }
          }
          else{
            Fluttertoast.showToast(msg: 'Update departure at origin!', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
        }
        else if(data?.arrivalPoint == 2){
          if(data?.dtVia1Departed != null){
            var minDate = data?.dtVia1Departed;
            if(context.mounted){
              showDialog(context: context, builder: (BuildContext updateContext){
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('Out for Delivery!'),
                  content: Text('Kindly update delivery to upload POD.'),
                  actions: [
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }, 'Cancel', Colors.red.shade700, Colors.white),
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateDeliveryLCLDialog(
                              intOrderId: intOrderId,
                              orderId: orderId,
                              minDate: minDate,xpcnId: xpcnId,
                              xpcnNum: xpcnCode,);
                          });
                    }, 'Update', Colors.blue.shade900, Colors.white),
                  ],
                );
              });
            }
          }
          else{
            Fluttertoast.showToast(msg: 'Update departure at Via-1', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
        }
        else if(data?.arrivalPoint == 3){
          if(data?.totalTallyDd == 2 && data?.dtVia1Departed == null){
            Fluttertoast.showToast(msg: 'Kindly update via 1 departure!', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
          else if(data?.totalTallyDd == 3 && data?.dtVia2Departed == null){
            Fluttertoast.showToast(msg: 'Kindly update via 2 departure!', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
          else if(data?.totalTallyDd == 1 && data?.originDepartedDate == null){
            Fluttertoast.showToast(msg: 'Trip not started yet!', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
          else if(data?.totalTallyDd == 1 && data?.originDepartedDate != null){
            var minDate = data?.originDepartedDate;
            if(context.mounted){
              showDialog(context: context, builder: (BuildContext updateContext){
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('Out for Delivery!'),
                  content: Text('Kindly update delivery to upload POD.'),
                  actions: [
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }, 'Cancel', Colors.red.shade700, Colors.white),
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateDeliveryLCLDialog(
                              intOrderId: intOrderId,
                              orderId: orderId,
                              minDate: minDate,xpcnId: xpcnId,
                              xpcnNum: xpcnCode,);
                          });
                    }, 'Update', Colors.blue.shade900, Colors.white),
                  ],
                );
              });
            }
          }
          else if(data?.totalTallyDd == 2 && data?.dtVia1Departed != null){
            var minDate = data?.dtVia1Departed;
            if(context.mounted){
              showDialog(context: context, builder: (BuildContext updateContext){
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('Out for Delivery!'),
                  content: Text('Kindly update delivery to upload POD.'),
                  actions: [
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }, 'Cancel', Colors.red.shade700, Colors.white),
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateDeliveryLCLDialog(
                              intOrderId: intOrderId,
                              orderId: orderId,
                              minDate: minDate,xpcnId: xpcnId,
                              xpcnNum: xpcnCode,);
                          });
                    }, 'Update', Colors.blue.shade900, Colors.white),
                  ],
                );
              });
            }
          }
          else if(data?.totalTallyDd == 3 && data?.dtVia2Departed != null){
            var minDate = data?.dtVia2Departed;
            if(context.mounted){
              showDialog(context: context, builder: (BuildContext updateContext){
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('Out for Delivery!'),
                  content: Text('Kindly update delivery to upload POD.'),
                  actions: [
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }, 'Cancel', Colors.red.shade700, Colors.white),
                    elevatedButtonWidget((){
                      Navigator.of(updateContext).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateDeliveryLCLDialog(
                              intOrderId: intOrderId,
                              orderId: orderId,
                              minDate: minDate,xpcnId: xpcnId,
                              xpcnNum: xpcnCode,);
                          });
                    }, 'Update', Colors.blue.shade900, Colors.white),
                  ],
                );
              });
            }
          }
          else{
            Fluttertoast.showToast(msg: 'Kindly update via 1 arrival!', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
            setState(() {
              isLoading = false;
            });
            await scannerController.start();
          }
        }
      }
      else if(data?.intXpcnStatus == 7){
        if(data?.dispatchIntrasitDate  != null){
          var minDate = data?.dispatchIntrasitDate;
          if(context.mounted){
            showDialog(context: context, builder: (BuildContext updateContext){
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Out for Delivery!'),
                content: Text('Kindly update delivery to upload POD.'),
                actions: [
                  elevatedButtonWidget((){
                    Navigator.of(updateContext).pop();
                    setState(() {
                      isLoading = false;
                    });
                  }, 'Cancel', Colors.red.shade700, Colors.white),
                  elevatedButtonWidget((){
                    Navigator.of(updateContext).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UpdateDeliveryLCLDialog(
                            intOrderId: intOrderId,
                            orderId: orderId,
                            minDate: minDate,xpcnId: xpcnId,
                            xpcnNum: xpcnCode,);
                        });
                  }, 'Update', Colors.blue.shade900, Colors.white),
                ],
              );
            });
          }
        }
        else{
          Fluttertoast.showToast(msg: 'Trip not started yet!', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
          setState(() {
            isLoading = false;
          });
          await scannerController.start();
        }
      }
    }
    else{
      setState(() {
        isLoading = false;
      });
      await scannerController.start();
    }
  }
  Future<void> _playBeep() async {
    await _audioPlayer.play(AssetSource('chime_sound.mp3'));
  }

  Uri? extractImageUri(String scannedDocString) {
    String scannedDocuments = scannedDocString;
    String? imageUri;

    // Use regex to extract the imageUri
    RegExp regExp = RegExp(r'imageUri=(.*?)\]');
    Match? match = regExp.firstMatch(scannedDocuments);

    if (match != null) {
      imageUri = match.group(1)!;
      // print("Extracted imageUri: $imageUri");
    } else {
      // print("No imageUri found.");
    }
    return Uri.parse(imageUri!); // Return the extracted URI
  }

  Future<void> scanDocument(String? xpcnCode) async {
    try {
      final scannedData = await FlutterDocScanner().getScannedDocumentAsImages(page: 1);
      if (scannedData == null || scannedData.isEmpty) {
        // debugPrint('Scanning failed: No document captured');
        Fluttertoast.showToast(msg: 'No Document Scanned', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
        setState(() {
          isLoading = false;
        });
        return;
      }
      // debugPrint('scanned result ==> ${scannedData.toString()}');

      String path = extractImageUri(scannedData.toString())!.path;
      path = path.replaceAll('%7D', '');

      File convertedFile = File(path);
      if(isFcl){
        await pod_upload_impl.uploadPodFcl(convertedFile, xpcnId, xpcnCode);
        await scannerController.start();
        setState(() {
          isLoading = false;
        });
      }
      else{
        await pod_upload_impl.uploadPodLcl(convertedFile, xpcnId, xpcnCode);
        await scannerController.start();
        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {
      // debugPrint('Unexpected error: $e');
      throw Exception(e);
    }
  }

  @override
  void initState(){
    isLoading = false;
    scannerController.start();
    super.initState();
  }

  MobileScannerController scannerController = MobileScannerController();
  String body_text = 'Align the barcode with the scanner field to scan XPCN barcode';
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: screenWidth*0.055),
        title: Text('Scan Barcode/Upload POD'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          heightSpacer(),
          !isLoading ? Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, blurRadius: 5, offset: Offset(2, 2)
                )
              ],

            ),
            height: 200,
            width: screenWidth*0.9,
            child: MobileScanner(
              controller: scannerController,
              onDetect: (capture) async{
                _playBeep();
                String? res;
                final List<Barcode> barcodes = capture.barcodes;
                if(barcodes[0].rawValue != null && barcodes.isNotEmpty){
                  res = barcodes[0].rawValue;
                  await fetchPodStatus(res, context);
                }
                else{
                  Fluttertoast.showToast(msg: 'Invalid Barcode, try again!', textColor: Colors.white, backgroundColor: Colors.grey.shade900);
                }
              },
              onDetectError: (error, stackTrace) {
                Fluttertoast.showToast(msg: 'Scanning Failed, try again!', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
              },
            )
          ) : SizedBox(height: 200, width: screenWidth*0.9,),
          heightSpacer(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(body_text, textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),),
          ),
          SizedBox(
            height: screenHeight*0.4,
            width: screenHeight*0.4,
            child: Lottie.asset('assets/scanner_page_animation.json'),
          ),
        ],
      ),
    );
  }

  Future presentView() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-screen height if needed
      backgroundColor: Colors.transparent, // Transparent background
      builder: (context) {
        return Loader();
      },
    );
  }
}

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

