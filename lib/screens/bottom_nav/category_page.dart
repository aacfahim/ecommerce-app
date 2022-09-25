import 'package:ecommerce/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var categoryList = Provider.of<CategoryProvider>(context).categoryList;
    return Scaffold(
        body: categoryList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          "https://apihomechef.antopolis.xyz/images/${categoryList[index].image ?? ""}",
                        ),
                      ),
                      Text("${categoryList[index].name}")
                    ],
                  );
                },
              ));
  }
}
