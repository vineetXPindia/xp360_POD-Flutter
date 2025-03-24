// To parse this JSON data, do
//
//     final lclXpcnStatusModel = lclXpcnStatusModelFromJson(jsonString);

import 'dart:convert';

LclXpcnStatusModel lclXpcnStatusModelFromJson(String str) => LclXpcnStatusModel.fromJson(json.decode(str));

String lclXpcnStatusModelToJson(LclXpcnStatusModel data) => json.encode(data.toJson());

class LclXpcnStatusModel {
  dynamic message;
  bool? success;
  Data? data;
  dynamic code;

  LclXpcnStatusModel({
    this.message,
    this.success,
    this.data,
    this.code,
  });

  factory LclXpcnStatusModel.fromJson(Map<String, dynamic> json) => LclXpcnStatusModel(
    message: json["Message"],
    success: json["Success"],
    data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
    code: json["Code"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Success": success,
    "Data": data?.toJson(),
    "Code": code,
  };
}

class Data {
  String? vcXpcnNo;
  int? intXpcnId;
  String? vcOrderId;
  int? intOrderId;
  String? vcXpcnStatus;
  int? intXpcnStatus;
  String? vcServiceType;
  int? intXptsId;
  dynamic intTallyId;
  int? arrivalPoint;
  dynamic dtVia1Arrival;
  dynamic dtVia2Arrival;
  dynamic dtDestinationArrival;
  DateTime? originDepartedDate;
  dynamic dtVia1Departed;
  dynamic dtVia2Departed;
  int? totalTallyDd;
  dynamic dispatchIntrasitDate;

  Data({
    this.vcXpcnNo,
    this.intXpcnId,
    this.vcOrderId,
    this.intOrderId,
    this.vcXpcnStatus,
    this.intXpcnStatus,
    this.vcServiceType,
    this.intXptsId,
    this.intTallyId,
    this.arrivalPoint,
    this.dtVia1Arrival,
    this.dtVia2Arrival,
    this.dtDestinationArrival,
    this.originDepartedDate,
    this.dtVia1Departed,
    this.dtVia2Departed,
    this.totalTallyDd,
    this.dispatchIntrasitDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    vcXpcnNo: json["vc_xpcn_no"],
    intXpcnId: json["int_xpcn_id"],
    vcOrderId: json["vc_order_id"],
    intOrderId: json["int_order_id"],
    vcXpcnStatus: json["vc_xpcn_status"],
    intXpcnStatus: json["int_xpcn_status"],
    vcServiceType: json["vc_service_type"],
    intXptsId: json["int_xpts_id"],
    intTallyId: json["int_tally_id"],
    arrivalPoint: json["arrival_point"],
    dtVia1Arrival: json["dt_via1_arrival"],
    dtVia2Arrival: json["dt_via2_arrival"],
    dtDestinationArrival: json["dt_destination_arrival"],
    originDepartedDate: json["origin_departed_date"] == null ? null : DateTime.parse(json["origin_departed_date"]),
    dtVia1Departed: json["dt_via1_departed"],
    dtVia2Departed: json["dt_via2_departed"],
    totalTallyDd: json["TOTAL_TALLY_DD"],
    dispatchIntrasitDate: json["Dispatch_intrasit_date"],
  );

  Map<String, dynamic> toJson() => {
    "vc_xpcn_no": vcXpcnNo,
    "int_xpcn_id": intXpcnId,
    "vc_order_id": vcOrderId,
    "int_order_id": intOrderId,
    "vc_xpcn_status": vcXpcnStatus,
    "int_xpcn_status": intXpcnStatus,
    "vc_service_type": vcServiceType,
    "int_xpts_id": intXptsId,
    "int_tally_id": intTallyId,
    "arrival_point": arrivalPoint,
    "dt_via1_arrival": dtVia1Arrival,
    "dt_via2_arrival": dtVia2Arrival,
    "dt_destination_arrival": dtDestinationArrival,
    "origin_departed_date": originDepartedDate?.toIso8601String(),
    "dt_via1_departed": dtVia1Departed,
    "dt_via2_departed": dtVia2Departed,
    "TOTAL_TALLY_DD": totalTallyDd,
    "Dispatch_intrasit_date": dispatchIntrasitDate,
  };
}
