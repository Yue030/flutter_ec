import 'package:flutter/material.dart';
import 'package:flutter_ec/widget/fade_in_network_image.dart';

import '../model/image_placeholder.dart';
import '../model/product.dart';
import '../product_detail_page.dart';

class ProductListWidget extends StatefulWidget {
  final List<Product> products;

  const ProductListWidget({super.key, required this.products});

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.products.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (_, index) {
        var item = widget.products[index];
        return ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: item))),
          leading: Hero(tag: item,
              child: SizedBox(
                width: 64,
                height: 64,
                child: item.medias.first.fileAgentData.mimeType.startsWith("image/") ? FadeInNetworkImage(url: item.medias.first.fileAgentData.url, fit: BoxFit.contain,) : const ImagePlaceholder(),
              )
          ),
          title: Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis,),
          subtitle: Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Text("\$${item.price.toInt().toString()}", style: const TextStyle(color: Colors.red)),
        );
      },
    );
  }
}
