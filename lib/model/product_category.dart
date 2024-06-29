class ProductCategory {
  final String productCategoryId;
  final String name;

  ProductCategory(this.productCategoryId, this.name);

  ProductCategory.fromJson(Map<String, dynamic> json)
    : productCategoryId = json["product_category_id"],
  name = json["name"];

  Map<String, dynamic> toJson() => {};
}