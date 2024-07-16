import 'package:flutter/material.dart';
import 'package:flutter_ec/widget/image_placeholder.dart';
import 'package:flutter_ec/util/http_util.dart';
import 'package:flutter_ec/widget/fade_in_network_image.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(3.0),
            child: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back),),
          ),
          title: const Text("訂單記錄")
      ),
      body: FutureBuilder(
        future: HttpUtil(context).getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.hasError) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("無法連接伺服器", style: TextStyle(fontSize: 30),),
                    ElevatedButton(onPressed: () { setState(() {

                    }); }, child: const Text("重新嘗試"))
                  ],
                ),
              ),
            );
          }

          final orders = snapshot.data!;

          final cards = List.generate(orders.length, (index) {
            final item = orders[index];

            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storefront),
                            const SizedBox(width: 10,),
                            Text(item.sellerAccount.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Text(item.orderStatus, style: const TextStyle(fontSize: 15),)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: List.generate(item.orderDetail.length, (index) {
                          final detail = item.orderDetail[index];
                          return Column(
                            children: [
                              Container(
                                height: 75,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: .5
                                        )
                                      ),
                                      child: detail.productSnapshot.medias.isNotEmpty
                                          ? FadeInNetworkImage(url: detail.productSnapshot.medias.firstWhere((element) => element.orderNo == 1).fileAgentData.url)
                                          : const ImagePlaceholder(),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(detail.productSnapshot.name, style: TextStyle(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  child: Text(detail.productSnapshot.description, style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                  width: 200,
                                                ),
                                                Text("x${detail.quantity}")
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text("\$${detail.price.toInt()}")
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              index == item.orderDetail.length - 1 ? Container() : SizedBox(height: 10,)
                            ],
                          );
                        }),
                      ),
                    ),
                    Container(
                      height: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item.orderDetail.length} 商品"),
                          Text("訂單金額: \$${item.total.toInt()}", style: TextStyle(color: Colors.red),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });

          return ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 25,
              );
            },
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return cards[index];
            }
          );
        },
      ),
    );
  }
}