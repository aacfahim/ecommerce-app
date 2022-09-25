import 'package:ecommerce/model/category_model.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> categoryList = [];

  Future getCategoryData() async {
    categoryList = await CustomHttp().fetchCategoryData();
    notifyListeners();
  }
}
