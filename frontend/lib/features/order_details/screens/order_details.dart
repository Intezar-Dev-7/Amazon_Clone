import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/features/admin/services/admin_services.dart';
import 'package:frontend/features/search/screens/search_screen.dart';
import 'package:frontend/models/order.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details-screen';
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  // !!! ONLY FOR ADMIN !!! //
  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(
      context: context,
      status: status,
      order: widget.order,
      onSuccess: () {
        setState(() {
          currentStep += 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        hintText: 'Search Products',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                        prefixIcon: InkWell(
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Microphone Icon
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "View Order Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Date:       ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}',
                    ),
                    Text('Order ID:        ${widget.order.id}'),
                    Text('Order Total: \$${widget.order.totalPrice}'),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                'Purchase Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      Row(
                        children: [
                          Image.network(
                            widget.order.products[i].images[0],
                            height: 120,
                            width: 120,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  widget.order.products[i].name,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('Qty: ${widget.order.quantity[i]}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tracking',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Stepper(
                  currentStep: currentStep,
                  controlsBuilder: (context, details) {
                    if (user.type == 'admin') {
                      return CustomElevatedButton(
                        text: 'Done',
                        onPressed: () => changeOrderStatus(details.currentStep),
                      );
                    }
                    return const SizedBox();
                  },

                  steps: [
                    Step(
                      title: const Text('Pending'),
                      content: const Text('Your order is yet to be delivered'),
                      isActive: currentStep > 0,
                      state:
                          currentStep > 0
                              ? StepState.complete
                              : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Completed'),
                      content: const Text('Your order has been delivered '),
                      isActive: currentStep > 1,
                      state:
                          currentStep > 1
                              ? StepState.complete
                              : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Received'),
                      content: const Text(
                        'Your order has been delivered adn signed by you',
                      ),
                      isActive: currentStep > 2,
                      state:
                          currentStep > 2
                              ? StepState.complete
                              : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Delivered'),
                      content: const Text(
                        'Your order has been delivered and signed by you ',
                      ),
                      isActive: currentStep > 3,
                      state:
                          currentStep > 3
                              ? StepState.complete
                              : StepState.indexed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
