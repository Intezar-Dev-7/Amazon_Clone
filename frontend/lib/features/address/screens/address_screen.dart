import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_snackbar.dart';
import 'package:frontend/common/widgets/custom_textfield.dart';
import 'package:frontend/features/address/services/addresses_services.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  /* a FocusNode is used to manage and control the focus of a widget—typically input widgets like TextField or TextFormField. It allows you to manually request, shift, or listen to focus changes.*/
  final FocusNode flatBuildingFocusNode = FocusNode();
  final FocusNode areaFocusNode = FocusNode();
  final FocusNode pincodeFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  String addressToBeUsed = "";
  List<PaymentItem> paymentItems = [];

  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();

    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();

    flatBuildingFocusNode.dispose();
    areaFocusNode.dispose();
    pincodeFocusNode.dispose();
    cityFocusNode.dispose();
  }

  final _addressFormKey = GlobalKey<FormState>();

  void onApplePayResult(res) {
    if (Provider.of(context, listen: false).user.address.isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: 'addressToBeUsed',
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (Provider.of(context, listen: false).user.address.isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: 'addressToBeUsed',
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = '';
    bool isForm =
        flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      } else {
        throw Exception("Please enter all the values");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text("address", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Or", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                ],
              ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                      focusNode: flatBuildingFocusNode,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                      focusNode: areaFocusNode,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                      focusNode: pincodeFocusNode,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                      focusNode: cityFocusNode,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              ApplePayButton(
                onPressed: () => payPressed(address),
                width: double.infinity,
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                  'applepay.json',
                ),
                onPaymentResult: onApplePayResult,

                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                height: 50,
              ),
              SizedBox(height: 10),
              GooglePayButton(
                onPressed: () => payPressed(address),
                type: GooglePayButtonType.buy,
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                  'gpay.json',
                ),
                paymentItems: paymentItems,
                onPaymentResult: onGooglePayResult,
                height: 50,
                margin: const EdgeInsets.only(top: 15),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
