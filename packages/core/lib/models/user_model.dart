
class UserModel {
  String name;
  String uid;
  String email;
  bool isEmailVerified;
  String mobile;
  bool isMobileVerified;
  String role;
  String createdAt;
  String updatedAt;
  String businessId;

  UserModel({
    this.name = '',
    this.uid = '',
    this.email = '',
    this.isEmailVerified = false,
    this.mobile = '',
    this.isMobileVerified = false,
    this.role = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.businessId = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      isEmailVerified: json['email_verified'] ?? false,
      mobile: json['mobile'] ?? '',
      isMobileVerified: json['mobile_verified'] ?? false,
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      businessId: json['business_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'email': email,
      'email_verified': isEmailVerified,
      'mobile': mobile,
      'mobile_verified': isMobileVerified,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'businessId': businessId,
    };
  }

  //parse list from list of map
  static List<UserModel> parseList(List<Map<String, dynamic>> json) {
    return json.map((e) => UserModel.fromJson(e)).toList();
  }

}