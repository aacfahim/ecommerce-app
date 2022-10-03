import 'package:ecommerce/common/const.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:flutter/material.dart';
import "dart:io";
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryName = TextEditingController();
  bool isVisible = false;
  bool onProgress = false;
  File? icon, image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future getIconFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        icon = File(pickedImage.path);
        print("Image Found");
        setState(() {
          isVisible = true;
        });
      } else {
        print("Image not found");
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
        print("Image Found");
        setState(() {
          isVisible = true;
        });
      } else {
        print("Image not found");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: onProgress,
      progressIndicator: spinkit,
      blur: 0.1,
      child: Scaffold(
        appBar: AppBar(title: Text("Add new Category")),
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: icon == null
                      ? InkWell(
                          onTap: () {
                            getIconFromGallery();
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.orange.withOpacity(0.15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.image), Text("Add Icon")],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.orange.withOpacity(0.15),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(icon!),
                              )),
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: image == null
                      ? InkWell(
                          onTap: () {
                            getImageFromGallery();
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.orange.withOpacity(0.15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image),
                                  Text("Add Image")
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.orange.withOpacity(0.15),
                              image: DecorationImage(
                                image: FileImage(image!),
                                fit: BoxFit.cover,
                              )),
                        ),
                )
              ],
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: categoryName,
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return showToast("Please enter the category name");
                  }
                }),
                decoration: InputDecoration(
                  label: Text("Enter Category Name"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (icon == null) {
                          showToast("Please upload a category icon");
                        } else if (image == null) {
                          showToast("Please upload category image");
                        } else {
                          setState(() {
                            onProgress = true;
                          });
                          CustomHttp().createCategory(
                              categoryName.text, icon!, image!, context);
                          setState(() {
                            onProgress = false;
                          });
                        }
                      }
                    },
                    child: Text("Save")))
          ]),
        ),
      ),
    );
  }
}
