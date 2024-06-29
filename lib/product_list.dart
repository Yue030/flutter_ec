import 'package:flutter/material.dart';
import 'package:flutter_ec/util/http_util.dart';
import 'package:flutter_ec/widget/product_grid_widget.dart';
import 'package:flutter_ec/widget/product_list_widget.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var isGridMode = true;
  String category = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 275,
                  child: FutureBuilder(
                    future: HttpUtil(context).getProductCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }

                      if (snapshot.hasError) {
                        return Container();
                      }

                      final data = List.generate(snapshot.data!.length, (index) {
                        return DropdownMenuItem(child: Text(snapshot.data![index].name), value: snapshot.data![index].productCategoryId,);
                      });

                      data.insert(0, const DropdownMenuItem(child: Text(""), value: "",));

                      return DropdownButton(items: data, onChanged: (val) {
                        category = val!;
                        setState(() {

                        });
                      }, value: category,);
                    }
                  )
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [

                IconButton(onPressed: isGridMode ? null : () { setState(() {
                  isGridMode = true;
                }); }, icon: const Icon(Icons.image), disabledColor: Colors.black, color: Colors.grey,),
                IconButton(onPressed: isGridMode ? () {setState(() {
                  isGridMode = false;
                });} : null, icon: const Icon(Icons.format_list_bulleted), disabledColor: Colors.black, color: Colors.grey,)
              ],)
            ],),
          ),
          Flexible(
            child: FutureBuilder(
              future: HttpUtil(context).getProduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }

                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("無法連接伺服器", style: TextStyle(fontSize: 30),),
                      ElevatedButton(onPressed: () { setState(() {

                      }); }, child: Text("重新嘗試"))
                    ],
                  );
                }

                var products = snapshot.requireData;

                if (category.isNotEmpty) {
                  products = products.where((element) => element.category.productCategoryId == category).toList();
                }

                return Padding(padding: const EdgeInsets.all(10), child: isGridMode ? ProductGridWidget(products: products)
                    : ProductListWidget(products: products),);
              },
            ),
          ),
        ],
      ),
    );
  }
}
