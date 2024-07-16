import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ec/widget/image_placeholder.dart';
import 'package:flutter_ec/model/product.dart';
import 'package:flutter_ec/shopping_car_page.dart';
import 'package:flutter_ec/util/http_util.dart';
import 'package:flutter_ec/widget/fade_in_network_image.dart';
import 'package:flutter_ec/widget/image_full_screen.dart';

import 'model/product_media.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late PageController _pageController;
  late List<ProductMedia> _medias;
  late List<Widget> _pages;
  var currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _medias = widget.product.medias.where((element) => element.fileAgentData.mimeType.startsWith("image/")).toList();
    _pages = List.generate(_medias.length, (index) {
      return GestureDetector(
        onTap: () async {
          final result = await Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ImageFullScreen(product: widget.product, index: index,),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var tween = Tween(
                  begin: const Offset(1.0, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOutCubic));

                return SlideTransition(position: animation.drive(tween), child: child,);
              },
              transitionDuration: const Duration(milliseconds: 200)
          ));

          setState(() {
            _pageController.jumpToPage(result as int);
          });
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: FadeInNetworkImage(url: _medias[index].fileAgentData.url, fit: BoxFit.cover,),),
            FadeInNetworkImage(url: _medias[index].fileAgentData.url, fit: BoxFit.contain,)
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final listPage = List.generate(_medias.length, (index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInCubic);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: currentPage == index + 1 ? Border.all(color: Colors.red, width: 1.5) : Border.all(color: Colors.black, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(6))
          ),
          child: FadeInNetworkImage(url: _medias[index].fileAgentData.url, fit: BoxFit.contain,),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back),),
        ),
        title: Text("${widget.product.name} - 商品詳情"),
      ),
      body: Container(
        color: Colors.black12,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: widget.product,
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 2.75,
                            child: _medias.isNotEmpty ? PageView.builder(
                              controller: _pageController,
                              itemCount: _medias.length,
                              itemBuilder: (context, index) {
                                return _pages[index];
                              },
                              onPageChanged: (newIndex) {
                                setState(() {
                                  currentPage = newIndex + 1;
                                });
                              },
                            ) : const ImagePlaceholder(),
                          ),
                        ),
                        Positioned(right: 10, bottom: 10,child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 50,
                              height: 20,
                              color: Colors.white60,
                              child: Center(child: Text("$currentPage/${_medias.isEmpty ? 1 : _medias.length}")),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _medias.isNotEmpty ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Text(_medias[currentPage - 1].description, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 75,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => SizedBox(width: 75, height: 75, child: listPage[index]),
                              separatorBuilder: (context, _) => const SizedBox(width: 12,),
                              itemCount: _medias.length
                            ),
                          ),
                        ],
                      ): SizedBox(
                        width: 75,
                        height: 75,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 1.5),
                              borderRadius: const BorderRadius.all(Radius.circular(6))
                          ),
                          child: Image.asset("assets/changli.png"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProductDetailBlock(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("\$${widget.product.price.toInt()}", style: const TextStyle(color: Colors.red, fontSize: 20),),
                        )
                      ],
                    ),
                  ),
                  ProductDetailBlock(
                      title: "賣家資訊",
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: widget.product.seller.avatar == null ? ImagePlaceholder() : FadeInNetworkImage(url: widget.product.seller.avatar!.url),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.product.seller.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.email, size: 20,),
                                    const SizedBox(width: 5,),
                                    Text(widget.product.seller.email)
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ProductDetailBlock(
                    title: "商品詳情",
                    sub: [
                      Row(
                        children: [
                          const Text("商品類別", style: TextStyle(fontSize: 15),),
                          const SizedBox(width: 75,),
                          Flexible(child: Text(widget.product.category.name, style: const TextStyle(fontSize: 15),))
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          const Text("商品標籤", style: TextStyle(fontSize: 15),),
                          const SizedBox(width: 75,),
                          Flexible(child: Text(widget.product.tags.join(","), style: const TextStyle(fontSize: 15),))
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          const Text("商品庫存", style: TextStyle(fontSize: 15),),
                          const SizedBox(width: 75,),
                          Flexible(child: Text(widget.product.storageQuantity.toString(), style: const TextStyle(fontSize: 15),))
                        ],
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Flexible(child: Text(widget.product.description, style: const TextStyle(fontSize: 13),))
                          ],
                        )
                      ],
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showShopModal(context, () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("將 ${widget.product.name} 加入購物車成功")));
                  Navigator.pop(context);
                });
              },
              child: Container(
                width: 120,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_shopping_cart, color: Colors.white, size: 20,),
                    Text("加入購物車", style: TextStyle(color: Colors.white, fontSize: 12))
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showShopModal(context, () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("將 ${widget.product.name} 加入購物車成功")));
                    Navigator.push(context, PageRouteBuilder(
                      pageBuilder: (context, ani, second) => ShoppingCarPage(),
                      transitionsBuilder: (context, ani, second, child) {
                        final tween = Tween(
                          begin: const Offset(1.0, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeInOut));

                        return SlideTransition(position: ani.drive(tween), child: child ,);
                      },
                      transitionDuration: const Duration(milliseconds: 600)
                    ));
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.red,
                  child: const Text("直接購買", style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showShopModal(BuildContext context, Function onPressed) {
    var quantity = 1;

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.black54,
        builder: (context) {
          return StatefulBuilder(builder:
              (context, setModelState) =>
              Container(
                height: 100,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("數量"),
                              Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(onPressed: quantity == 1 ? null : () {
                                        setModelState(() {
                                          quantity -= 1;
                                        });
                                      }, icon: const Icon(Icons.remove)),
                                      Text(quantity.toString(),),
                                      IconButton(onPressed: quantity == widget.product.storageQuantity ? null : () {
                                        setModelState(() {
                                          quantity += 1;
                                        });
                                      }, icon: const Icon(Icons.add)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, -1)
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: () async {
                          await HttpUtil(context).addShoppingCar(widget.product.productId, quantity);

                          if (mounted) {
                            onPressed();
                          }
                        }, child: Text("加入購物車")),
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}

class ProductDetailBlock extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? sub;
  const ProductDetailBlock({super.key, required this.child, this.title, this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title == null ? Container() : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              ),
              const Divider(height: 1, color: Colors.black)
            ],
          ),
          sub == null ? Container() : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: sub!,
                ),
              ),
              const Divider(height: 1, color: Colors.black)
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          )
        ],
      ),
    );
  }
}
