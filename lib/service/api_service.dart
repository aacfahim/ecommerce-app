import 'dart:convert';

import 'package:ecommerce/common/const.dart';
import 'package:ecommerce/model/order_model.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttp {
  static const Map<String, String> defaultHeader = {
    "Accept": "application/json",
  };

  Future<Map<String, String>> getHeaderWithToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var map = {
      "Accept": "application.json",
      "Authorization": "bearer ${sharedPreferences.getString("token")}",
    };

    return map;
  }

  Future<String> loginUser(String email, String password) async {
    var link = "${baseURL}api/admin/sign-in";

    var map = Map<String, dynamic>();
    map = {"email": email, "password": password};

    var response =
        await http.post(Uri.parse(link), body: map, headers: defaultHeader);

    // print("${response.body}");

    if (response.statusCode == 200) {
      showToast('Login Successful');
      return response.body;
    } else {
      showToast('Something went wrong');
      return "Failed";
    }
  }

  Future<List<OrderModel>> fetchOrderData() async {
    List<OrderModel> orderList = [];
    OrderModel orderModel;

    var link = "${baseURL}api/admin/all/orders";

    var response =
        await http.get(Uri.parse(link), headers: await getHeaderWithToken());

    try {
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (var i in data) {
          orderModel = OrderModel.fromJson(i);
          orderList.add(orderModel);
        }
        return orderList;
      } else {
        showToast("${response.statusCode} Something went wrong");
        return orderList;
      }
    } catch (e) {
      print(e);
      return orderList;
    }
  }
}
