
class BusinessModel {
  String logo;
  String name;
  String address;
  String businessId;
  String mobile;
  bool isSetupCompleted;
  String token;
  String adminId;
  String registrationNo;
  List<String> orderPreference;
  List<String> paymentOptions;
  String createdAt;
  String updatedAt;

  BusinessModel({
    required this.logo,
    required this.name,
    this.address = '',
    required this.businessId,
    required this.mobile,
    this.isSetupCompleted = false,
    this.token = '',
    this.adminId = '',
    this.registrationNo = '',
    this.orderPreference = const [],
    this.paymentOptions = const [],
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      logo: json['logo'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      businessId: json['business_id'] ?? '',
      mobile: json['mobile'] ?? '',
      isSetupCompleted: json['is_setup_completed'] ?? false,
      token: json['token'] ?? '',
      adminId: json['admin_id'] ?? '',
      registrationNo: json['registration_no'] ?? '',
      orderPreference: json['order_preference'] != null ? List.from(json['order_preference']) : [],
      paymentOptions: json['payment_options'] != null ? List.from(json['payment_options']) : [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'logo': logo,
      'name': name,
      'address': address,
      'business_id': businessId,
      'mobile': mobile,
      'is_setup_completed': isSetupCompleted,
      'token': token,
      'admin_id': adminId,
      'registration_no': registrationNo,
      'order_preference': orderPreference,
      'payment_options': paymentOptions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}