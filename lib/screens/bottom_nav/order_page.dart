import 'package:ecommerce/model/order_model.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderModel> orderList = [];

  @override
  void didChangeDependencies() async {
    orderList = await CustomHttp().fetchOrderData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: orderList.length,
      itemBuilder: ((context, index) {
        return ListTile(
          title: Text("${orderList[index].id}"),
        );
      }),
    ));
  }
}
