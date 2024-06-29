import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/changli.png", fit: BoxFit.cover,);
  }
}
