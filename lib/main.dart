import 'package:flutter/material.dart';
import 'package:flutter_ec/product_page.dart';

import 'global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global.initSharePrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '電商購物平台',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: '啟動頁面'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProductPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("電商購物平台", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
            ClipOval(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Image.asset("assets/changli.png", fit: BoxFit.cover),
              ),
            )
          ],
        ),
      )
    );
  }
}
