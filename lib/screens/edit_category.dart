import 'package:ecommerce/common/const.dart';
import 'package:ecommerce/model/category_model.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:flutter/material.dart';
import "dart:io";
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditCategory extends StatefulWidget {
  EditCategory({super.key, required this.categoryModel});
  CategoryModel? categoryModel;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController categoryName = TextEditingController();
  @override
  void initState() {
    categoryName = TextEditingController(
      text: widget.categoryModel!.name,
    );
    super.initState();
  }

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
      progressIndicator: CircularProgressIndicator(),
      blur: 0.3,
      child: Scaffold(
        appBar: AppBar(title: Text("Update Category")),
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
                              child: Image.network(
                                  "$imageURL${widget.categoryModel!.icon}",
                                  fit: BoxFit.cover),
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
                              child: Image.network(
                                  "$imageURL${widget.categoryModel!.image}",
                                  fit: BoxFit.cover),
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
                        /* Loading screen doesnt appear while adding cat */
                        setState(() {
                          onProgress = true;
                        });
                        CustomHttp().updateCategory(categoryName.text, icon,
                            image, widget.categoryModel!.id, context);
                        setState(() {
                          onProgress = false;
                        });
                      }
                    },
                    child: Text("Update Category")))
          ]),
        ),
      ),
    );
  }
}
