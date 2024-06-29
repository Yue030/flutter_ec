import 'package:flutter/material.dart';
import 'package:flutter_ec/register_page.dart';
import 'package:flutter_ec/util/http_util.dart';

import 'global.dart';

class LoginPage extends StatefulWidget {
  final Widget? target;
  const LoginPage({super.key, this.target});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back),),
        ),
        title: const Text("登入"),
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
                  child: Image.asset("assets/changli.png", width: 192, height: 192,),
                ),
                const Text("電商購物平台", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,),),
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

                    final token = await HttpUtil(context).getUserToken(emailController.value.text, passwordController.value.text);
                    Global.setJwt(token);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("登入成功")));
                      if (widget.target == null) {
                        Navigator.pop(context);
                        return;
                      }
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.target!));
                    }
                   }, child: const Text("登入"))
                ),
                const SizedBox(height: 30,),
                SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    }, child: const Text("註冊"))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
