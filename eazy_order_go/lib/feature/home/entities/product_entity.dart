
import 'package:image_picker/image_picker.dart';

class ProductEntity {
  final List<XFile> images;
  final String productName;
  final double price;
  final String desc;
  final bool isValid;
  final bool isLoading;

    ProductEntity({
    this.images = const [],
    this.productName = '',
    this.price = 0.0,
    this.desc = '',
    this.isValid = false,
    this.isLoading = false,
  });

  ProductEntity copyWith({List<XFile>? images, String? productName, double? price, String? desc,
    bool? isValid, bool? isLoading}) {
    return ProductEntity(
      images: images ?? this.images,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      desc: desc ?? this.desc,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}