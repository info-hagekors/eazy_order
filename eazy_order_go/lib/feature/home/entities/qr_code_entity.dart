
import 'package:core/core.dart';

class QrCodeEntity {
  final String logo;
  final BusinessModel? businessModel;


  QrCodeEntity({
    this.logo = '',
    this.businessModel,
  });

  QrCodeEntity copyWith({String? logo, BusinessModel? businessModel}) {
    return QrCodeEntity(
      logo: logo ?? this.logo,
      businessModel: businessModel ?? this.businessModel,
    );
  }
}