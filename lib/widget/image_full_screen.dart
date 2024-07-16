import 'package:flutter/material.dart';
import 'package:flutter_ec/model/product.dart';
import 'package:flutter_ec/widget/fade_in_network_image.dart';

import 'image_placeholder.dart';
import '../model/product_media.dart';

class ImageFullScreen extends StatefulWidget {
  final Product product;
  final int index;

  const ImageFullScreen({super.key, required this.product, this.index = 0});

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  late PageController _pageController;
  late List<ProductMedia> _medias;
  late List<Widget> _pages;
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    _pageController = PageController(initialPage: widget.index);
    _medias = widget.product.medias
        .where((element) => element.fileAgentData.mimeType.startsWith("image/"))
        .toList();

    _pages = List.generate(_medias.length, (index) {
      return FadeInNetworkImage(url: _medias[index].fileAgentData.url, fit: BoxFit.contain,);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, currentIndex);
          return false;
        },
        child: Container(
          color: Colors.black,
          child: SizedBox(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _medias.isNotEmpty
                    ? PageView.builder(
                        controller: _pageController,
                        itemCount: _medias.length,
                        itemBuilder: (context, index) {
                          return _pages[index];
                        },
                        onPageChanged: (newIndex) {
                          setState(() {
                            currentIndex = newIndex;
                          });
                        },
                      )
                    : const ImagePlaceholder(),
                Positioned(
                  left: 10,
                  top: 50,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.red,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context, currentIndex);
                    },
                  ),
                ),
                Positioned(
                  bottom: 50,
                  child: Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _medias.length,
                        (index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: currentIndex == index
                                      ? Colors.red
                                      : Colors.white,
                                ),
                              ),
                            )),
                    ),
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
