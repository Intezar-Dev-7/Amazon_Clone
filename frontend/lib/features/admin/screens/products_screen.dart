import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/loader.dart';
import 'package:frontend/features/account/widgets/single_product.dart';
import 'package:frontend/features/admin/screens/add_product_screen.dart';
import 'package:frontend/features/admin/services/admin_services.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/utils/constants/colors.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
          body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: products?.length ?? 0,
            itemBuilder: (context, index) {
              final productData = products![index];
              return Column(
                children: [
                  SizedBox(
                    height: 140,
                    child: SingleProduct(image: productData.images[0]),
                  ),
                  // Row widget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Expanded(
                        child: Text(
                          productData.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        onPressed: () => deleteProduct(productData, index),
                        icon: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: selectedNavBarColor,
            onPressed: navigateToAddProduct,
            tooltip: 'Add a product',
            child: Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
  }
}
