import 'package:ecommerce/providers/category_provider.dart';
import 'package:ecommerce/providers/order_provider.dart';
import 'package:ecommerce/screens/add_category.dart';
import 'package:ecommerce/screens/bottom_nav_page.dart';
import 'package:ecommerce/screens/sign_in.dart';
import 'package:ecommerce/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => OrderProvider())),
        ChangeNotifierProvider(create: ((context) => CategoryProvider())),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
