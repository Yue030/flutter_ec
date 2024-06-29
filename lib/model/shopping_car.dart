import 'package:flutter_ec/model/product.dart';

class ShoppingCar {
  final String shoppingCarId;
  final Product product;
  final int quantity;

  ShoppingCar(this.shoppingCarId, this.product, this.quantity);

  ShoppingCar.fromJson(Map<String, dynamic> json):
      shoppingCarId = json["shopping_car_id"],
      product = Product.fromJson(json["product"]),
      quantity = json["quantity"];

  Map<String, dynamic> toJson() => {};
}