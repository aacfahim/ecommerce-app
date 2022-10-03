import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

String baseURL = "https://apihomechef.antopolis.xyz/";

String imageURL = "https://apihomechef.antopolis.xyz/images/";

showToast(String message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 16.0);
}

const spinkit = SpinKitPouringHourGlass(
  color: Colors.orange,
  size: 50.0,
);
