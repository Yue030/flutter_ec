import 'dart:ffi';

import 'package:flutter_ec/model/account_information.dart';
import 'package:flutter_ec/model/product_category.dart';
import 'package:flutter_ec/model/product_media.dart';

class Product {
  final String productId;
  final AccountInformation seller;
  final String name;
  final String description;
  final double price;
  final int storageQuantity;
  final String sellStatus;
  final ProductCategory category;
  final List<ProductMedia> medias;
  final List<String> tags;
  final String createDateTime;


  Product(
      this.productId,
      this.seller,
      this.name,
      this.description,
      this.price,
      this.storageQuantity,
      this.sellStatus,
      this.category,
      this.medias,
      this.tags,
      this.createDateTime);


  Product.fromJson(Map<String, dynamic> json):
      productId = json["product_id"],
  seller = AccountInformation.fromJson(json["seller"]),
  name = json["name"],
  description = json["description"],
  price = json["price"],
  storageQuantity = json["storage_quantity"],
  sellStatus = json["sell_status"],
  category = ProductCategory.fromJson(json["product_category"]),
  medias = (json["product_medias"] as List<dynamic>).map((e) => ProductMedia.fromJson(e)).toList(),
  tags = (json["tags"] as List<dynamic>).map((e) => e.toString()).toList(),
  createDateTime = json["create_date_time"];

  Map<String, dynamic> toJson() => {};
}