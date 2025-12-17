class ProductListEntity {
  final String productname;
  final int price;
  final int quantity;
  final String description;

  ProductListEntity({
    this.productname = "",
    this.price = 0,
    this.quantity = 0,
    this.description = "",
  });

  ProductListEntity copyWith({
    String? productname,
    int? price,
    int? quantity,
    String? description,
  }) {
    return ProductListEntity(
      productname: productname ?? this.productname,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
    );
  }
}
