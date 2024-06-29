import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ec/login_page.dart';
import 'package:flutter_ec/model/account_information.dart';
import 'package:flutter_ec/model/product_category.dart';

import '../global.dart';
import '../model/buyer_order.dart';
import '../model/product.dart';

import '../model/shopping_car.dart';

class HttpUtil {
  late Dio _dio;

  final baseUrl = "http://192.168.0.241:5000/";

  HttpUtil(BuildContext context) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl
    ));
    _dio.interceptors.add(AuthInterceptor(context: context));
  }

  Future<Response> _request(String path, {required String method, Object? data}) async {
    try {
      return await _dio.request(path, options: Options(method: method), data: jsonEncode(data));
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e);
    }
  }

  Future<Response> get(String path) async {
    return _request(path, method: 'get');
  }

  Future<Response> post(String path, Object data) async {
    return _request(path, method: 'post', data: data);
  }

  Future<Response> put(String path, Object data) async {
    return _request(path, method: 'put', data: data);
  }

  Future<Response> delete(String path) async {
    return _request(path, method: 'delete');
  }

  Future<List<Product>> getProduct() async {
    final response = await get("public/product");
    return (response.data["value"] as List<dynamic>).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<ProductCategory>> getProductCategory() async {
    final response = await get("public/product-category");
    return (response.data["value"] as List<dynamic>).map((e) => ProductCategory.fromJson(e)).toList();
  }

  Future<String> getUserToken(String email, String password) async {
    final response = await post("public/account/user-token", {
      "email": email,
      "password": password
    });
    return response.data["token"] as String;
  }
  
  Future<void> register(String email, String name, String password, String role) async {
    await post("public/account/register", {
      "email": email,
      "name": name,
      "password": password,
      "role_type": role
    });
  }

  Future<AccountInformation> getBuyerInfo() async {
    final response = await get("public/account");
    return AccountInformation.fromJson(response.data);
  }

  Future editAccountInfo(String name) async {
    await put("public/account", {
      "name": name
    });
  }

  Future editAccountPassword(String oldPassword, String newPassword) async {
    await put("public/account/password", {
      "old_password": oldPassword,
      "new_password": newPassword
    });
  }

  Future<List<ShoppingCar>> getShoppingCar() async {
    final response = await get("buyer/shopping-car");
    return (response.data["value"] as List<dynamic>).map((e) => ShoppingCar.fromJson(e)).toList();
  }

  Future<ShoppingCar> addShoppingCar(String productId, int quantity) async {
   final response = await post("buyer/shopping-car", {
     "product_id": productId,
     "quantity": quantity
   });
   return ShoppingCar.fromJson(response.data);
  }

  Future updateShoppingCar(String shoppingCarId, int quantity) async {
    await put("buyer/shopping-car/$shoppingCarId", {
      "quantity": quantity
    });
  }

  Future<List<BuyerOrder>> getOrders() async {
    final response = await get("buyer/order");
    return (response.data["value"] as List<dynamic>).map((e) => BuyerOrder.fromJson(e)).toList();
  }

  Future postOrder(List<String> shoppingCars, String address, String receiverName, String receiverPhone) async {
    await post("buyer/order", {
      "shopping_car_ids": shoppingCars,
      "address": address,
      "receiver_name": receiverName,
      "receiver_phone": receiverPhone
    });
  }
}

class AuthInterceptor extends Interceptor {
  final BuildContext context;
  
  AuthInterceptor({required this.context});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    
    options.headers["Content-Type"] = "application/json";
    String? jwt = Global.getJwt();
    if (jwt != null && jwt.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $jwt";
    }
  }
  
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    final msg = err.response?.data["message"];
    if (err.response?.statusCode == 400) {
      if (msg == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("發生未知錯誤")));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg!)));
      return;
    }

    if (err.response?.statusCode == 401 && err.response?.data["result_code"] != "email_or_password_incorrect") {
      Global.setJwt(null);

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
            pageBuilder: (context, animation, secondAnimation) => LoginPage(),
            transitionsBuilder: (context, animation, second, child) {
              final tween = Tween(
                begin: const Offset(0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut));

              return SlideTransition(position: animation.drive(tween), child: child,);
            },
            transitionDuration: Duration(milliseconds: 400)), (route) => route.isFirst
        );
      }
    }
  }
}