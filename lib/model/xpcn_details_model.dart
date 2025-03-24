// To parse this JSON data, do
//
//     final xpcnDetailsModel = xpcnDetailsModelFromJson(jsonString);

import 'dart:convert';

XpcnDetailsModel xpcnDetailsModelFromJson(String str) => XpcnDetailsModel.fromJson(json.decode(str));

String xpcnDetailsModelToJson(XpcnDetailsModel data) => json.encode(data.toJson());

class XpcnDetailsModel {
  bool? success;
  String? message;
  List<XpcnDetailsData>? data;
  dynamic code;

  XpcnDetailsModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory XpcnDetailsModel.fromJson(Map<String, dynamic> json) => XpcnDetailsModel(
    success: json["Success"],
    message: json["Message"],
    data: json["Data"] == null ? [] : List<XpcnDetailsData>.from(json["Data"]!.map((x) => XpcnDetailsData.fromJson(x))),
    code: json["Code"],
  );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "Message": message,
    "Data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "Code": code,
  };
}

class XpcnDetailsData {
  String? result;
  String? xpcnCode;
  DateTime? xpcnDate;
  String? consignorName;
  String? consigneeName;
  String? consigneeGst;
  String? consignorGst;
  int? totalBoxes;
  dynamic deliveryDate;
  dynamic origin;
  dynamic destination;
  String? customerName;
  dynamic poLr;
  String? service;
  String? cofStatus;
  String? orderId;
  List<EwayDetail>? ewayDetails;
  List<InvoiceDetail>? invoiceDetails;
  String? ewaybillNo;
  String? ewaybillDate;
  String? invoiceDate;
  String? invoiceNo;
  String? invoiceValue;

  XpcnDetailsData({
    this.result,
    this.xpcnCode,
    this.xpcnDate,
    this.consignorName,
    this.consigneeName,
    this.consigneeGst,
    this.consignorGst,
    this.totalBoxes,
    this.deliveryDate,
    this.origin,
    this.destination,
    this.customerName,
    this.poLr,
    this.service,
    this.cofStatus,
    this.orderId,
    this.ewayDetails,
    this.invoiceDetails,
    this.ewaybillNo,
    this.ewaybillDate,
    this.invoiceDate,
    this.invoiceNo,
    this.invoiceValue,
  });

  factory XpcnDetailsData.fromJson(Map<String, dynamic> json) => XpcnDetailsData(
    result: json["result"],
    xpcnCode: json["XpcnCode"],
    xpcnDate: json["XpcnDate"] == null ? null : DateTime.parse(json["XpcnDate"]),
    consignorName: json["ConsignorName"],
    consigneeName: json["ConsigneeName"],
    consigneeGst: json["ConsigneeGST"],
    consignorGst: json["ConsignorGST"],
    totalBoxes: json["TotalBoxes"],
    deliveryDate: json["DeliveryDate"],
    origin: json["Origin"],
    destination: json["Destination"],
    customerName: json["CustomerName"],
    poLr: json["PoLr"],
    service: json["Service"],
    cofStatus: json["COFStatus"],
    orderId: json["orderId"],
    ewayDetails: json["ewayDetails"] == null ? [] : List<EwayDetail>.from(json["ewayDetails"]!.map((x) => EwayDetail.fromJson(x))),
    invoiceDetails: json["invoiceDetails"] == null ? [] : List<InvoiceDetail>.from(json["invoiceDetails"]!.map((x) => InvoiceDetail.fromJson(x))),
    ewaybillNo: json["EwaybillNo"],
    ewaybillDate: json["EwaybillDate"],
    invoiceDate: json["InvoiceDate"],
    invoiceNo: json["InvoiceNo"],
    invoiceValue: json["InvoiceValue"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "XpcnCode": xpcnCode,
    "XpcnDate": xpcnDate?.toIso8601String(),
    "ConsignorName": consignorName,
    "ConsigneeName": consigneeName,
    "ConsigneeGST": consigneeGst,
    "ConsignorGST": consignorGst,
    "TotalBoxes": totalBoxes,
    "DeliveryDate": deliveryDate,
    "Origin": origin,
    "Destination": destination,
    "CustomerName": customerName,
    "PoLr": poLr,
    "Service": service,
    "COFStatus": cofStatus,
    "orderId": orderId,
    "ewayDetails": ewayDetails == null ? [] : List<dynamic>.from(ewayDetails!.map((x) => x.toJson())),
    "invoiceDetails": invoiceDetails == null ? [] : List<dynamic>.from(invoiceDetails!.map((x) => x.toJson())),
    "EwaybillNo": ewaybillNo,
    "EwaybillDate": ewaybillDate,
    "InvoiceDate": invoiceDate,
    "InvoiceNo": invoiceNo,
    "InvoiceValue": invoiceValue,
  };
}

class EwayDetail {
  String? ewaybillNo;
  String? ewaybillDate;
  dynamic invoiceDate;
  dynamic invoiceNo;
  dynamic invoiceValue;

  EwayDetail({
    this.ewaybillNo,
    this.ewaybillDate,
    this.invoiceDate,
    this.invoiceNo,
    this.invoiceValue,
  });

  factory EwayDetail.fromJson(Map<String, dynamic> json) => EwayDetail(
    ewaybillNo: json["EwaybillNo"],
    ewaybillDate: json["EwaybillDate"],
    invoiceDate: json["InvoiceDate"],
    invoiceNo: json["InvoiceNo"],
    invoiceValue: json["InvoiceValue"],
  );

  Map<String, dynamic> toJson() => {
    "EwaybillNo": ewaybillNo,
    "EwaybillDate": ewaybillDate,
    "InvoiceDate": invoiceDate,
    "InvoiceNo": invoiceNo,
    "InvoiceValue": invoiceValue,
  };
}

class InvoiceDetail {
  String? invoiceDate;
  String? invoiceNo;
  String? invoiceValue;

  InvoiceDetail({
    this.invoiceDate,
    this.invoiceNo,
    this.invoiceValue,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
    invoiceDate: json["InvoiceDate"],
    invoiceNo: json["InvoiceNo"],
    invoiceValue: json["InvoiceValue"],
  );

  Map<String, dynamic> toJson() => {
    "InvoiceDate": invoiceDate,
    "InvoiceNo": invoiceNo,
    "InvoiceValue": invoiceValue,
  };
}
