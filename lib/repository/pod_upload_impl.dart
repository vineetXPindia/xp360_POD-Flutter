import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../constants/Api_Constants.dart';
import '../model/lcl_xpcn_status_model.dart';
import '../model/xpcn_details_model.dart';


class PodUploadImpl{

  XpcnDetailsModel detailsModel = XpcnDetailsModel();
  LclXpcnStatusModel? lclXpcnStatusModel;

  int? xpcnId;

  Future<String?> getXpcnDetails(String? xpcnCode) async{
    String? result;
    // for QA
    final headers = {
      "userId" : "VuCrhNvv3zM-3D-",
      "applicationId" : "2078"
    };
    // for Live
    // final headers = {
    //   "userId" : "odtD-2B-Ekx-2B-FA-3D-",
    //   "applicationId" : "18926"
    // };
    try{
      final response = await http.get(Uri.parse(ApiConstants.get_fcl_lcl_pod_details).replace(queryParameters: {"XPCN" : xpcnCode}), headers: headers);
      final jsonData = jsonDecode(response.body);
      if(response.statusCode == 200) {
        if(jsonData['Success'] == true){
          detailsModel = xpcnDetailsModelFromJson(response.body);
          if(detailsModel.data![0].result == 'LCL'){
            result = 'LCL';
          }
          else if(detailsModel.data![0].result == 'FCL'){
            result = 'FCL';
          }
        }
        else{
          Fluttertoast.showToast(msg: 'Unable to get details for this XPCN', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
        }
      }
      else{
        Fluttertoast.showToast(msg: 'Invalid XPCN Barcode', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
      }
      return result;
    }
    catch(e){
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getFclXpcnStatus(String? xpcnCode) async{
    // for QA
    final headers = {
      "userId" : "VuCrhNvv3zM-3D-",
      "applicationId" : "2078"
    };
    // for Live
    // final headers = {
    //   "userId" : "odtD-2B-Ekx-2B-FA-3D-",
    //   "applicationId" : "18926"
    // };
    Map<String, dynamic> status = {};
    try{
      final response = await http.get(Uri.parse(ApiConstants.get_fcl_status).replace(queryParameters: {"xpcn" : "$xpcnCode"}), headers: headers);
      final jsonData = jsonDecode(response.body);
      if(response.statusCode == 200){
        if(jsonData['Success'] == true){
          status = jsonData['Data'];
        }
      }
      else{
        Fluttertoast.showToast(msg: 'Unable to fetch status');
      }
      return status;
    }
    catch(e){
      throw Exception(e);
    }
  }

  Future<LclXpcnStatusModel?> getLclXpcnStatus(String? xpcnCode) async{
    // for QA
    final headers = {
      "userId" : "VuCrhNvv3zM-3D-",
      "applicationId" : "2078"
    };
    // for Live
    // final headers = {
    //   "userId" : "odtD-2B-Ekx-2B-FA-3D-",
    //   "applicationId" : "18926"
    // };
    try{
      final response = await http.get(Uri.parse(ApiConstants.get_lcl_status).replace(queryParameters: {"vc_xpcn_no" : "$xpcnCode"}), headers: headers);
      final jsonData = jsonDecode(response.body);
      if(response.statusCode == 200){
        if(jsonData['Success'] == true){
          lclXpcnStatusModel = lclXpcnStatusModelFromJson(response.body);
        }
        else{
          Fluttertoast.showToast(msg: 'No Record Found', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
        }
      }
      else{
        Fluttertoast.showToast(msg: 'Unable to fetch status', textColor: Colors.white, backgroundColor: Colors.grey.shade800);
      }
      return lclXpcnStatusModel;
    }
    catch(e){
      throw Exception(e);
    }
  }

  Future<void> uploadPodFcl(File file, String? xpcnId, String? xpcnNum) async {
    // await initializeUser();
    String? message;
    var url = Uri.parse(ApiConstants.save_xpcn_pod);
    var request = http.MultipartRequest('POST', url);

    // for QA
    request.headers['UserId'] = 'VuCrhNvv3zM-3D-';
    request.headers['applicationId'] = '$xpcnId';

    // for Live
    // request.headers['UserId'] = 'odtD-2B-Ekx-2B-FA-3D-';
    // request.headers['applicationId'] = '${18926}';

    // Add other form fields
    Map<String, dynamic> fields = {
      'XPCNId' : '$xpcnId',
      'XPCNNumber' : xpcnNum,
      'DocUrl' : null,
      'isValidated' : true
    };
    String jsonString = jsonEncode(fields);
    request.fields['FormData'] = jsonString;

    var contentType = lookupMimeType(file.path) ?? 'application/octet-stream';
    var imageStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('Doc', imageStream, length, filename: 'image', contentType: MediaType.parse(contentType));
    // Attach the file
    request.files.add(multipartFile);
    // Send the request
    var response = await request.send();
    // Read response
    var responseBody = await response.stream.bytesToString();
    final jsonData = jsonDecode(responseBody);
    message = jsonData['Message'];
    if(jsonData['Success'] == true){
      Fluttertoast.showToast(msg: '$message', textColor: Colors.white, backgroundColor: Colors.green.shade700);
    }
    else{
      Fluttertoast.showToast(msg: '$message', textColor: Colors.white, backgroundColor: Colors.red.shade800);
    }
  }

  Future<void> uploadPodLcl(File file, String? xpcnId, String? xpcnNum) async {
    String? message;
    var url = Uri.parse(ApiConstants.save_xpcn_pod_lcl);
    var request = http.MultipartRequest('POST', url);

    // for QA
    request.headers['UserId'] = 'VuCrhNvv3zM-3D-';
    request.headers['applicationId'] = '${2078}';

    // for Live
    // request.headers['UserId'] = 'odtD-2B-Ekx-2B-FA-3D-';
    // request.headers['applicationId'] = '${18926}';

    Map<String, dynamic> fields = {
      'XPCNId' : '$xpcnId',
      'XPCNNumber' : xpcnNum,
      'DocUrl' : null,
      'isValidated' : true,
      'isPOD' : true,
      'CODdate' : null,
      'DocCOD' : '',
      'VACReason' : null,
      'DocUrlCOD' : '',
      'pod_remark' : ''
    };
    String jsonString = jsonEncode(fields);
    request.fields['FormData'] = jsonString;

    var contentType = lookupMimeType(file.path) ?? 'application/octet-stream';
    var imageStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('Doc', imageStream, length, filename: 'image', contentType: MediaType.parse(contentType));
    // Attach the file
    request.files.add(multipartFile);
    // Send the request
    var response = await request.send();
    // Read response
    var responseBody = await response.stream.bytesToString();
    final jsonData = jsonDecode(responseBody);
    message = jsonData['Message'];
    if(jsonData['Success'] == true){
      Fluttertoast.showToast(msg: '$message', textColor: Colors.white, backgroundColor: Colors.green.shade700);
    }
    else{
      Fluttertoast.showToast(msg: '$message', textColor: Colors.white, backgroundColor: Colors.red.shade700);
    }
  }

  Future<bool> updateDelivery(int? intOrderId, String? date, String? time) async{
    bool isUpdated = false;
    String? message;
    try{
      final response = await http.get(Uri.parse('${ApiConstants.update_validate_delivery_order_arrival_dest}?int_order_id=$intOrderId&dt_arrival_date=$date%20$time'));
      final jsonData = jsonDecode(response.body);
      message = jsonData['Message'];
      if(jsonData['Success'] == true){
        Fluttertoast.showToast(msg: '$message', textColor: Colors.white, backgroundColor: Colors.green.shade700);
        isUpdated = true;
      }
      else{
        Fluttertoast.showToast(msg: 'Unable to update delivery', textColor: Colors.white, backgroundColor: Colors.red.shade700);
      }
      return isUpdated;
    }
    catch(e){
      throw Exception(e);
    }
  }
}