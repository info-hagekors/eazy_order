
class AdminPinEntity {
  final String pin;
  final String confirmPin;
  final bool isValid;

  AdminPinEntity({
    this.pin = '',
    this.confirmPin = '',
    this.isValid = false,
  });

  AdminPinEntity copyWith({String? pin, String? confirmPin, bool? isValid}) {
    return AdminPinEntity(
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
      isValid: isValid ?? this.isValid,
    );
  }
}