import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String baseURL = "https://apihomechef.antopolis.xyz/";

showToast(String message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 16.0);
}