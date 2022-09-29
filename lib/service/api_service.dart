import 'dart:convert';
import 'dart:io';

import 'package:ecommerce/common/const.dart';
import 'package:ecommerce/model/category_model.dart';
import 'package:ecommerce/model/order_model.dart';
import 'package:flutter/cupertino.dart';
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

  Future<List<CategoryModel>> fetchCategoryData() async {
    List<CategoryModel> categoryList = [];
    CategoryModel categoryModel;

    var link = "${baseURL}api/admin/category";

    var response =
        await http.get(Uri.parse(link), headers: await getHeaderWithToken());

    try {
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (var i in data) {
          categoryModel = CategoryModel.fromJson(i);
          categoryList.add(categoryModel);
        }
        return categoryList;
      } else {
        showToast("${response.statusCode} Something went wrong");
        return categoryList;
      }
    } catch (e) {
      print(e);
      return categoryList;
    }
  }

  createCategory(var name, dynamic icon, dynamic image) async {
    var link = Uri.parse("${baseURL}api/admin/category/store");

    var request = http.MultipartRequest("POST", link);
    request.headers.addAll(await getHeaderWithToken());

    request.fields["name"] = name.toString(); // for sending text only

    // for sending media files
    icon = await http.MultipartFile.fromPath("icon", icon!.path);
    image = await http.MultipartFile.fromPath("image", image!.path);

    request.files.add(icon);
    request.files.add(image);

    var response = await request.send();

    if (response.statusCode == 200) {
      showToast("Operation completed");
    } else {
      showToast("Failed");
    }
  }
}
