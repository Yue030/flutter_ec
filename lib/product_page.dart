import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ec/account_page.dart';
import 'package:flutter_ec/login_page.dart';
import 'package:flutter_ec/product_list.dart';
import 'package:flutter_ec/shopping_car_page.dart';

import 'global.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.asset("assets/changli.png"),
            ),
          ),
          title: const Text("電商購物平台"),
          actions: [
            IconButton(onPressed: () => {
              if (Global.getJwt() == null) {
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation, second) => const LoginPage(target: ShoppingCarPage()),
                  transitionsBuilder: (context, animation, second, child) {
                    return SlideTransition(position: animation.drive(Tween(
                      begin: const Offset(0, 1.0),
                      end: Offset.zero
                    ).chain(CurveTween(curve: Curves.easeInOut)),), child: child,);
                  },
                  transitionDuration: const Duration(milliseconds: 400)
                )).then((value) => setState(() {

                })),
              } else {
                Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ShoppingCarPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var tween = Tween(
                        begin: const Offset(1.0, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeInOut));

                      return SlideTransition(position: animation.drive(tween), child: child,);
                    },
                    transitionDuration: const Duration(milliseconds: 600)
                )).then((value) => setState(() {

                }))
              }
            }, icon: const Icon(Icons.shopping_cart))
          ],
        ),
        body: TabBarView(physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            ProductList(),
            AccountPage()
        ],),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: Container(
            color: Colors.red,
            child: TabBar(
              controller: _controller,
                indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                  color: Colors.white,
                  width: 2
              ),
              insets: EdgeInsets.symmetric(horizontal:1.0),
            ),
              labelStyle: const TextStyle(fontSize: 15),
              tabs: const [
                Tab(icon: Icon(Icons.home, size: 20,), text: "主頁", iconMargin: EdgeInsets.zero,),
                Tab(icon: Icon(Icons.account_box, size: 20,), text: "個人頁面", iconMargin: EdgeInsets.zero)
            ]),
          ),
        ),
      ),
    );
  }
}
