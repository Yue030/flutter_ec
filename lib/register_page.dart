import 'package:flutter/material.dart';
import 'package:flutter_ec/util/http_util.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back),),
        ),
        title: const Text("註冊"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: Image.asset(
                    "assets/changli.png", width: 192, height: 192,),
                ),
                const Text("電商購物平台", style: TextStyle(
                  fontSize: 40, fontWeight: FontWeight.bold,),),
                const SizedBox(height: 50,),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 275,
                  height: 100,
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "電子郵件"
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "電子郵件不可為空";
                      }

                      if (!(value.contains("@") && value.contains("."))) {
                        return "電子郵件驗證失敗";
                      }

                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 275,
                  height: 100,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "暱稱"
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "暱稱不可為空";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 275,
                  height: 100,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "密碼"
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "密碼不可為空";
                      }

                      if (value != rePasswordController.text) {
                        return "密碼必須與確認密碼相同";
                      }

                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 275,
                  height: 100,
                  child: TextFormField(
                    controller: rePasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "確認密碼",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "密碼不可為空";
                      }

                      if (value != passwordController.text) {
                        return "密碼必須與確認密碼相同";
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                    await HttpUtil(context).register(emailController.text, nameController.text, passwordController.text, "buyer");

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("註冊成功")));
                      Navigator.pop(context);
                    }
                    }, child: const Text("確認註冊"))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
