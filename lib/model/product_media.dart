import 'package:flutter_ec/model/file_agent_data.dart';

class ProductMedia {
  final String productMediaId;
  final FileAgentData fileAgentData;
  final String description;

  ProductMedia(this.productMediaId, this.fileAgentData, this.description);

  ProductMedia.fromJson(Map<String, dynamic> json) :
      productMediaId = json["product_media_id"],
  fileAgentData = FileAgentData.fromJson(json["file_agent_data"]),
  description = json["description"];

  Map<String, dynamic> toJson() => {};
}