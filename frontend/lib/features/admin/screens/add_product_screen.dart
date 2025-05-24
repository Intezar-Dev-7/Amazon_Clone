import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/custom_textfield.dart';
import 'package:frontend/features/admin/services/admin_services.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:frontend/utils/utils.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  // Focus Nodes
  final FocusNode productNameFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();

  String category = 'Mobile';
  final _addProductKeyForm = GlobalKey<FormState>();
  final AdminServices adminServices = AdminServices();

  // Dispose all the TextEditing Controllers and Focus Nodes
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();

    productNameFocus.dispose();
    descriptionFocus.dispose();
    priceFocus.dispose();
    quantityFocus.dispose();
  }

  List<File> images = [];

  List<String> productCategories = [
    'Mobile',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];

  void sellProduct() {
    if (_addProductKeyForm.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: category,
        images: images,
      );
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: appBarGradient),
          ),
          title: Text("Add Products", style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductKeyForm,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                images.isNotEmpty
                    ? CarouselSlider(
                      items:
                          images.map((i) {
                            return Builder(
                              builder:
                                  (BuildContext context) => Image.file(
                                    i,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                            );
                          }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        height: 200,
                      ),
                    )
                    : GestureDetector(
                      onTap: selectImages,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: [10, 4],
                        strokeCap: StrokeCap.round,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.folder_open, size: 40),
                              const SizedBox(height: 15),
                              Text(
                                "Select Product Images",
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Enter product name',
                  focusNode: productNameFocus,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Enter product description',
                  focusNode: descriptionFocus,
                  maxLines: 7,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                  focusNode: priceFocus,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                  focusNode: quantityFocus,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Category', style: TextStyle(fontSize: 18)),
                    DropdownButton(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: Colors.grey.shade100,
                      value: category,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items:
                          productCategories.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (String? newVal) {
                        setState(() {
                          category = newVal!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(text: 'Sell', onPressed: sellProduct),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
