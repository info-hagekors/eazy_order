

class CreateUserResponseModel {
  String message;
  String uid;
  String resetLink;

  CreateUserResponseModel({
    this.message = '',
    this.uid = '',
    this.resetLink = '',
  });

  factory CreateUserResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateUserResponseModel(
      message: json['message'] ?? '',
      uid: json['uid'] ?? '',
      resetLink: json['reset_link'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'uid': uid,
      'reset_link': resetLink,
    };
  }
}