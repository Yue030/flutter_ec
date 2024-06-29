import 'package:flutter_ec/model/account_information.dart';
import 'package:flutter_ec/model/product_category.dart';

import 'file_agent_data.dart';

class BuyerOrder {
  final String orderId;
  final AccountInformation sellerAccount;
  final String address;
  final String receiverName;
  final String receiverPhone;
  final String orderStatus;
  final double total;
  final List<OrderDetail> orderDetail;
  final DateTime createDateTime;

  BuyerOrder(
      this.orderId,
      this.sellerAccount,
      this.address,
      this.receiverName,
      this.receiverPhone,
      this.orderStatus,
      this.total,
      this.orderDetail,
      this.createDateTime);

  BuyerOrder.fromJson(Map<String, dynamic> json):
      orderId = json["order_id"],
  sellerAccount = AccountInformation.fromJson(json["seller_account"]),
  address = json["address"],
  receiverPhone = json["receiver_phone"],
  receiverName = json["receiver_name"],
  orderStatus = json["order_status"],
  total = json["total"],
  orderDetail = (json["order_details"] as List<dynamic>).map((e) => OrderDetail.fromJson(e)).toList(),
  createDateTime = DateTime.parse(json["create_date_time"]);

  Map<String, dynamic> toJson() => {};
}

class OrderDetail {
  final String orderDetailId;
  final int quantity;
  final double price;
  final ProductSnapshot productSnapshot;

  OrderDetail(
      this.orderDetailId, this.quantity, this.price, this.productSnapshot);

  OrderDetail.fromJson(Map<String, dynamic> json):
      orderDetailId = json["order_detail_id"],
  quantity = json["quantity"],
  price = json["price"],
  productSnapshot = ProductSnapshot.fromJson(json["product_snapshot"]);

  Map<String, dynamic> toJson() => {};
}

class ProductSnapshot {
  final String productSnapshotId;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;
  final List<ProductSnapshotMedia> medias;


  ProductSnapshot(
      this.productSnapshotId,
      this.name,
      this.description,
      this.price,
      this.category,
      this.medias);


  ProductSnapshot.fromJson(Map<String, dynamic> json):
        productSnapshotId = json["product_snapshot_id"],
        name = json["name"],
        description = json["description"],
        price = json["price"],
        category = ProductCategory.fromJson(json["product_category"]),
        medias = (json["product_snapshot_medias"] as List<dynamic>).map((e) => ProductSnapshotMedia.fromJson(e)).toList();

  Map<String, dynamic> toJson() => {};
}

class ProductSnapshotMedia {
  final String productSnapshotMediaId;
  final FileAgentData fileAgentData;
  final int orderNo;

  ProductSnapshotMedia(this.productSnapshotMediaId, this.fileAgentData, this.orderNo);

  ProductSnapshotMedia.fromJson(Map<String, dynamic> json) :
        productSnapshotMediaId = json["product_snapshot_media_id"],
        fileAgentData = FileAgentData.fromJson(json["file_agent_data_response"]),
  orderNo = json["order_no"];

  Map<String, dynamic> toJson() => {};
}