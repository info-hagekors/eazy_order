import 'package:eazy_order_pro/feature/catalog/entity/product_list_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_listing_controller.g.dart';

@Riverpod(keepAlive: true)
class ProductListingController extends _$ProductListingController{
  @override
  ProductListEntity build() {
    return ProductListEntity();
  }
}