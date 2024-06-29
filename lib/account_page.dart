import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ec/login_page.dart';
import 'package:flutter_ec/model/image_placeholder.dart';
import 'package:flutter_ec/util/http_util.dart';
import 'package:flutter_ec/widget/fade_in_network_image.dart';
import 'global.dart';
import 'order_history_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: Global.getJwt() != null ? HttpUtil(context).getBuyerInfo() : Future.value(null),
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

              final info = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 5,
                      child: SizedBox(
                        width: 400,
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 3),
                                    shape: BoxShape.circle
                                ),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(48),
                                    child: info == null ? ImagePlaceholder() : info.avatar != null ?
                                      FadeInNetworkImage(url: info.avatar!.url, fit: BoxFit.cover,)
                                        : ImagePlaceholder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                                child: info == null ? ElevatedButton(onPressed: (){
                                  Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (context, ani, secondAni) => const LoginPage(),
                                    transitionsBuilder: (context, ani, secondAni, child) {
                                      final tween = Tween(
                                        begin: const Offset(0, 1.0),
                                        end: Offset.zero,
                                      ).chain(CurveTween(curve: Curves.easeInOut));

                                      return SlideTransition(position: ani.drive(tween), child: child,);
                                    },
                                    transitionDuration: const Duration(milliseconds: 400)
                                  )).then((value) => setState(() {

                                  }));
                                }, child: Text("登入")) :
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(info.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.account_circle_rounded, size: 20,),
                                        const SizedBox(width: 5,),
                                        Text(info.roleType, style: const TextStyle(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.email, size: 20,),
                                        const SizedBox(width: 5,),
                                        Text(info.email, style: const TextStyle(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          info == null ? Container() : MaterialButton(onPressed: (){}, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.favorite),
                                    SizedBox(width: 10,),
                                    Text("我的最愛", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          ),
                          info == null ? Container() : MaterialButton(onPressed: (){
                            final formKey = GlobalKey<FormState>();
                            final nameController = TextEditingController();
                            showDialog(context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    title: const Text("修改帳號資訊"),
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: "暱稱",
                                              ),
                                              controller: nameController,
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
                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }

                                        await HttpUtil(context).editAccountInfo(nameController.text);

                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("修改帳號資訊成功")));
                                          Navigator.pop(context);
                                          setState(() {

                                          });
                                        }
                                      }, child: const Text("確認更改"))
                                    ],
                                  );
                                }
                            );
                          }, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.edit_note),
                                    SizedBox(width: 10,),
                                    Text("編輯帳號", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          ),
                          info == null ? Container() : MaterialButton(onPressed: (){
                            final formKey = GlobalKey<FormState>();
                            final pwController = TextEditingController();
                            final newPwController = TextEditingController();
                            showDialog(context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    title: const Text("修改密碼"),
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: "舊密碼",
                                              ),
                                              controller: pwController,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return "欄位不可為空";
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: "新密碼",
                                              ),
                                              controller: newPwController,
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
                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }

                                        await HttpUtil(context).editAccountPassword(pwController.text, newPwController.text);

                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("更改密碼成功")));
                                          Navigator.pop(context);
                                          setState(() {

                                          });
                                        }
                                      }, child: const Text("更改密碼"))
                                    ],
                                  );
                                }
                            );
                          }, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.password),
                                    SizedBox(width: 10,),
                                    Text("修改密碼", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          ),
                          info == null ? Container() : MaterialButton(onPressed: (){
                            Navigator.push(context, PageRouteBuilder(
                                pageBuilder: (context, ani, secondAni) => const OrderHistoryPage(),
                                transitionsBuilder: (context, ani, secondAni, child) {
                                  final tween = Tween(
                                    begin: const Offset(1.0, 0),
                                    end: Offset.zero,
                                  ).chain(CurveTween(curve: Curves.easeInOut));

                                  return SlideTransition(position: ani.drive(tween), child: child,);
                                },
                                transitionDuration: const Duration(milliseconds: 400)
                            )).then((value) => setState(() {

                            }));
                          }, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_cart_rounded),
                                    SizedBox(width: 10,),
                                    const Text("訂單記錄", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          ),
                          MaterialButton(onPressed: (){}, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.settings),
                                    SizedBox(width: 10,),
                                    const Text("設定", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          ),
                          MaterialButton(onPressed: (){}, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.info),
                                    SizedBox(width: 10,),
                                    const Text("關於", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          ),
                          info == null ? Container() : MaterialButton(onPressed: (){
                            Global.setJwt(null);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("登出成功")));
                            setState(() {

                            });
                          }, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.logout, color: Colors.red,),
                                    SizedBox(width: 10,),
                                    const Text("登出", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),)
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios, color: Colors.red,)
                              ],
                            ),
                          ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
              ),
        ),
      ),
    );
  }
}
