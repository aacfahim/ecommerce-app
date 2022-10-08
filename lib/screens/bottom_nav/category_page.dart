import 'package:ecommerce/providers/category_provider.dart';
import 'package:ecommerce/screens/add_category.dart';
import 'package:ecommerce/screens/edit_category.dart';
import 'package:ecommerce/service/api_service.dart';
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
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddCategory()))
                  .then((value) =>
                      Provider.of<CategoryProvider>(context, listen: false)
                          .getCategoryData());
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.deepOrange),
        body: categoryList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Card(
                            semanticContainer: true,
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        "https://apihomechef.antopolis.xyz/images/${categoryList[index].image ?? ""}"),
                                  )),
                              child: Align(
                                alignment: Alignment.center,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://apihomechef.antopolis.xyz/images/${categoryList[index].icon ?? ""}"),
                                  ),
                                  title: Text(
                                    "${categoryList[index].name}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                              // bottomLeft
                                              offset: Offset(-1.5, -1.5),
                                              color: Colors.black),
                                          Shadow(
                                              // bottomRight
                                              offset: Offset(1.5, -1.5),
                                              color: Colors.black),
                                          Shadow(
                                              // topRight
                                              offset: Offset(1.5, 1.5),
                                              color: Colors.black),
                                          Shadow(
                                              // topLeft
                                              offset: Offset(-1.5, 1.5),
                                              color: Colors.black),
                                        ],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => EditCategory(
                                              categoryModel:
                                                  categoryList[index],
                                            )))).then((value) =>
                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .getCategoryData());
                              },
                              child: Text("Edit")),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          Text("Are you sure want to delete?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            CustomHttp().deleteCategory(
                                                categoryList[index].id);
                                            Navigator.pop(context, 'OK');
                                            Provider.of<CategoryProvider>(
                                                    context,
                                                    listen: false)
                                                .getCategoryData();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text("Delete")),
                        ],
                      )
                    ],
                  );
                },
              ));
  }
}
