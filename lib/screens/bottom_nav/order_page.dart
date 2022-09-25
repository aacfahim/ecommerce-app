import 'package:ecommerce/model/order_model.dart';
import 'package:ecommerce/providers/order_provider.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // List<OrderModel> orderList = [];

  // @override
  // void didChangeDependencies() async {
  //   orderList = await CustomHttp().fetchOrderData();
  //   super.didChangeDependencies();
  // }

  //with providers, can be used with stateless widget

  @override
  Widget build(BuildContext context) {
    // using provider
    var orderProvider = Provider.of<OrderProvider>(context).getOrderData();
    var orderList = Provider.of<OrderProvider>(context).orderList;

    return Scaffold(
        body: ListView.builder(
      itemCount: orderList.length,
      itemBuilder: ((context, index) {
        return ListTile(
          subtitle:
              Text("${orderList[index].orderStatus!.orderStatusCategory!.id}"),
          title: Text(
              "${orderList[index].orderStatus!.orderStatusCategory!.name}"),
        );
      }),
    ));
  }
}
