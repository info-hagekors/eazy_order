class ProductListEntity {
  final Map<String, int> cart;

  const ProductListEntity({
    this.cart = const {},
  });

  int get totalItems =>
      cart.values.fold(0, (sum, qty) => sum + qty);

  int get totalPrice =>
      cart.values.fold(0, (sum, qty) => sum + (qty * 100));

  ProductListEntity copyWith({
    Map<String, int>? cart,
  }) {
    return ProductListEntity(
      cart: cart ?? this.cart,
    );
  }
}
