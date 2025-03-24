class ApiConstants{
  static const String baseUrl = 'https://qaapi.xpindia.in/api';
  static const String coreUrl = 'https://qacore.xpindia.in/api/v2';

  // static const String baseUrl = 'https://liveapi.xpindia.in/api';
  // static const String coreUrl = 'https://coreapi.xpindia.in/api/v2';

  static const String send_otp_for_login = '$baseUrl/send-otp-for-login'; // ?phoneNumber=
  static const String validate_otp = '$baseUrl/login-using-otp'; // ?phoneNumber=9634090220&otp=8326

  static const String get_fcl_lcl_pod_details = '$coreUrl/get-fcl-lcl-detail'; // ?XPCN=XPCN/LDH01/3428
  static const String get_fcl_status = '$baseUrl/get-fcl-xpcn-status-by-scan'; // ?xpcn=1000000514
  static const String get_lcl_status = '$baseUrl/get_xpcn_status_pud_app'; // ?vc_xpcn_no=20000004261
  static const String save_xpcn_pod = '$baseUrl/save-xpcn-pod';
  static const String save_xpcn_pod_lcl = '$baseUrl/save-xpcn-pod-lcl';

  static const String update_validate_delivery_order_arrival_dest = '$baseUrl/update-validate-delivery-order-arrival-dest';

}