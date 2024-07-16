import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ec/widget/image_placeholder.dart';
import 'package:flutter_ec/product_detail_page.dart';
import 'package:flutter_ec/widget/fade_in_network_image.dart';

import '../model/product.dart';

class ProductGridWidget extends StatefulWidget {
  final List<Product> products;

  const ProductGridWidget({super.key, required this.products});

  @override
  State<ProductGridWidget> createState() => _ProductGridWidgetState();
}

class _ProductGridWidgetState extends State<ProductGridWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75),
        itemCount: widget.products.length,
        itemBuilder: (_, index) {
          final item = widget.products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: item)));
            },
            child: GridTile(
              child: Card(
                clipBehavior: Clip.hardEdge,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Hero(
                      tag: item,
                      child: SizedBox(
                        width: 192,
                        height: 192,
                        child: Stack(
                          children: [
                            item.medias.isNotEmpty &&
                                    item.medias.first.fileAgentData.mimeType
                                        .startsWith("image/")
                                ? ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                        sigmaY: 5.0, sigmaX: 5.0),
                                    child: FadeInNetworkImage(
                                      url: item.medias.first.fileAgentData.url,
                                      width: 172,
                                      height: 172,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                            Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: item.medias.isNotEmpty &&
                                          item.medias.first.fileAgentData
                                              .mimeType
                                              .startsWith("image/")
                                      ? FadeInNetworkImage(
                                          url: item
                                              .medias.first.fileAgentData.url,
                                          width: 192,
                                          height: 192,
                                          fit: BoxFit.contain,
                                        )
                                      : const ImagePlaceholder()),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "\$${item.price.toInt()}",
                      style: const TextStyle(color: Colors.red),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
