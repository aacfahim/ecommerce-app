import 'package:ecommerce/model/order_model.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> orderList = [];

  Future getOrderData() async {
    orderList = await CustomHttp().fetchOrderData();
    notifyListeners();
  }
}
