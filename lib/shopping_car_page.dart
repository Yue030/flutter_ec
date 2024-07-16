import 'package:flutter/material.dart';
import 'package:flutter_ec/product_detail_page.dart';
import 'package:flutter_ec/util/http_util.dart';
import 'package:flutter_ec/widget/fade_in_network_image.dart';

import 'widget/image_placeholder.dart';
import 'model/shopping_car.dart';

class ShoppingCarPage extends StatefulWidget {
  const ShoppingCarPage({super.key});

  @override
  State<ShoppingCarPage> createState() => _ShoppingCarPageState();
}

class _ShoppingCarPageState extends State<ShoppingCarPage> {
  Set<String> selected = <String>{};
  List<ShoppingCar> cars = [];
  bool selectAll = true;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back),),
        ),
        title: const Text("購物車")
      ),
      body: FutureBuilder(
          future: HttpUtil(context).getShoppingCar(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("無法連接伺服器", style: TextStyle(fontSize: 30),),
                  ElevatedButton(onPressed: () { setState(() {

                  }); }, child: const Text("重新嘗試"))
                ],
              );
            }

            cars = snapshot.data!;

            if (selectAll) {
              selected.addAll(cars.map((e) => e.shoppingCarId));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (_, index) {
                      final car = cars[index];
                      return Dismissible(
                        onDismissed: (_) async {
                          await HttpUtil(context).updateShoppingCar(car.shoppingCarId, 0);

                          setState(() {

                          });
                        },
                        background: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text("刪除", style: TextStyle(color: Colors.white, fontSize: 15),),
                              ],
                            ),
                          ),
                        ),
                        dismissThresholds: const {
                          DismissDirection.endToStart: 0.5
                        },
                        direction: DismissDirection.endToStart,
                        key: Key(car.shoppingCarId),
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(value: selected.contains(car.shoppingCarId), onChanged: (val) {
                                  if (selected.contains(car.shoppingCarId)) {
                                    selected.remove(car.shoppingCarId);
                                  } else {
                                    selected.add(car.shoppingCarId);
                                  }
                                  selectAll = selected.length == cars.length;

                                  setState(() {

                                  });
                                }),
                              ),
                              SizedBox(width: 5,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (context, ani, second) => ProductDetailPage(product: car.product),
                                    transitionsBuilder: (context, ani, second, child) {
                                      final tween = Tween(
                                        begin: const Offset(1.0, 0),
                                        end: Offset.zero
                                      ).chain(CurveTween(curve: Curves.easeInOut));

                                      return SlideTransition(position: ani.drive(tween), child: child,);
                                    },
                                    transitionDuration: const Duration(milliseconds: 400)
                                  )).then((value) => setState(() {}));
                                },
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: car.product.medias.first.fileAgentData.mimeType.startsWith("image/") ? FadeInNetworkImage(url: car.product.medias.first.fileAgentData.url, fit: BoxFit.contain,) : const ImagePlaceholder(),
                                ),
                              ),
                            ],
                          ),
                          title: Text(car.product.name, maxLines: 1, overflow: TextOverflow.ellipsis,),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.product.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.account_circle),
                                  SizedBox(width: 2.5,),
                                  Text(car.product.seller.name,)
                                ],
                              )
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Text("\$${car.product.price.toInt().toString()}", style: const TextStyle(color: Colors.red)),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: () async {
                                    await HttpUtil(context).updateShoppingCar(car.shoppingCarId, car.quantity - 1);

                                    if (car.quantity - 1 == 0) {
                                      selected.remove(car.shoppingCarId);
                                    }

                                    setState(() {

                                    });
                                  }, icon: const Icon(Icons.remove)),
                                  Text(car.quantity.toString(),),
                                  IconButton(onPressed: () async {
                                    await HttpUtil(context).updateShoppingCar(car.shoppingCarId, car.quantity + 1);
                                    setState(() {

                                    });
                                  }, icon: const Icon(Icons.add)),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 60,
                  child: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(fillColor: MaterialStateProperty.resolveWith((states) {
                              return Colors.white;
                            }), checkColor: Colors.red, value: selectAll, onChanged: (val) {
                              selectAll = !selectAll;

                              selected.clear();
                              if (selectAll) {
                                selected.addAll(cars.map((e) => e.shoppingCarId));
                              }

                              setState(() {

                              });
                            }),
                            const Text("全選", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "總金額 \$${selected.isNotEmpty ? cars.where((element) => selected.contains(element.shoppingCarId))
                                    .map((e) => e.product.price.toInt() * e.quantity)
                                    .reduce((value, element) => value + element).toString() : 0}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),
                              ),
                            ),
                            MaterialButton(onPressed: () {
                              if (selected.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請至少選擇一項商品")));
                                return;
                              }

                              showDialog(context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text("結帳"),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              TextFormField(
                                                decoration: const InputDecoration(
                                                  labelText: "收件者姓名",
                                                ),
                                                controller: nameController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "欄位不可為空";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                decoration: const InputDecoration(
                                                  labelText: "收件者電話號碼",
                                                ),
                                                controller: phoneController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "欄位不可為空";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                decoration: const InputDecoration(
                                                  labelText: "收件地址",
                                                ),
                                                controller: addressController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "欄位不可為空";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(onPressed: () async {
                                          if (!_formKey.currentState!.validate()) {
                                            return;
                                          }

                                          await HttpUtil(context).postOrder(selected.toList(), addressController.text, nameController.text, phoneController.text);

                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("訂單建立成功")));
                                            Navigator.popUntil(context, (route) => route.isFirst);
                                          }
                                        }, child: const Text("送出訂單"))
                                      ],
                                    );
                                  }
                              );
                            },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                              color: Colors.white,
                              height: 100,
                              child: const Text("結帳", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),)
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
      )
    );
  }
}
