import 'package:flutter/material.dart';

class FadeInNetworkImage extends StatefulWidget {
  final String url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  const FadeInNetworkImage({super.key, required this.url, this.fit, this.width, this.height});

  @override
  State<FadeInNetworkImage> createState() => _FadeInNetworkImageState();
}

class _FadeInNetworkImageState extends State<FadeInNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: "assets/changli.png",
      image: widget.url,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset("assets/changli.png", width: widget.width, height: widget.height, fit: widget.fit,);
      },
    );
  }
}
