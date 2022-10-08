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

        return List.from(categoryList.reversed);
      } else {
        showToast("${response.statusCode} Something went wrong");
        return categoryList;
      }
    } catch (e) {
      print(e);
      return categoryList;
    }
  }

  Future createCategory(
      var name, dynamic icon, dynamic image, BuildContext context) async {
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
    print("response code: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      showToast("Operation completed");
      Navigator.of(context).pop();
    } else {
      showToast("Failed");
    }
  }

  Future updateCategory(var name, dynamic icon, dynamic image, dynamic id,
      BuildContext context) async {
    var link = Uri.parse("${baseURL}api/admin/category/$id/update");

    var request = http.MultipartRequest("POST", link);
    request.headers.addAll(await getHeaderWithToken());

    request.fields["name"] = name.toString(); // for sending text only

    // for sending media files

    if (icon != null) {
      var iconFile = await http.MultipartFile.fromPath("icon", icon.path);
      request.files.add(iconFile);
    }

    if (image != null) {
      var imageFile = await http.MultipartFile.fromPath("image", image.path);
      request.files.add(imageFile);
    }

    var response = await request.send();
    // Fetching the response data in byte format from the server and parsing to string
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    var data = jsonDecode(responseString);
    print("byte data: $data");

    print("response code: ${response.statusCode}");

    if (response.statusCode == 200) {
      showToast("Category Updated");
      Navigator.of(context).pop();
    } else {
      showToast("Failed");
    }
  }
}
