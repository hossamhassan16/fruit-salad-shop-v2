import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fruite_salad_shop/utils/keys.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'package:fruite_salad_shop/cubits/cart_cubit/cart_cubit_cubit.dart';
import 'package:fruite_salad_shop/widgets/order_success_page.dart';

class CheckoutPage extends StatefulWidget {
  final String clientName;
  final LatLng? confirmedLocation;

  const CheckoutPage({
    super.key,
    required this.clientName,
    this.confirmedLocation,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedMethod = 'PayPal';
  final List<String> methods = ['PayPal', 'Cash on Delivery', 'Stripe'];

  double calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, e) => sum + e.item.price * e.quantity);
  }

  List<Map<String, dynamic>> generatePayPalItems(List<CartItem> items) {
    return items
        .map((e) => {
              "name": e.item.name,
              "quantity": e.quantity,
              "price": e.item.price.toString(),
              "currency": "USD",
            })
        .toList();
  }

  Future<void> storeOrder({
    required String clientName,
    required List<CartItem> items,
    required String paymentMethod,
  }) async {
    final orderData = {
      'totalPrice': calculateTotal(items),
      'paymentMethod': paymentMethod,
      'timestamp': Timestamp.now(),
      'items': items
          .map((e) => {
                'name': e.item.name,
                'price': e.item.price,
                'quantity': e.quantity,
              })
          .toList(),
      if (widget.confirmedLocation != null)
        'deliveryLocation': {
          'latitude': widget.confirmedLocation!.latitude,
          'longitude': widget.confirmedLocation!.longitude,
        },
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(clientName)
        .collection('orders')
        .add(orderData);
  }

  Future<void> handleStripePayment(List<CartItem> cartItems) async {
    try {
      final total = calculateTotal(cartItems);
      final amountInCents = (total * 100).toInt();

      final stripeSecretKey = Keys.stripeSecretKey;
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': 'usd',
          'payment_method_types[]': 'card',
        },
      );

      final body = jsonDecode(response.body);
      final clientSecret = body['client_secret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Fruit Salad Shop',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception('Stripe payment failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final cartItems = cartCubit.state;

    final paypalClientId = Keys.paypalClientID;
    final paypalSecretKey = Keys.paypalSecretKey;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Payment Method:',
                style: TextStyle(fontSize: 18)),
            ...methods.map((method) => RadioListTile(
                  title: Text(method),
                  value: method,
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value!;
                    });
                  },
                )),
            const SizedBox(height: 20),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (selectedMethod == 'PayPal') {
                    final total = calculateTotal(cartItems).toStringAsFixed(2);
                    final items = generatePayPalItems(cartItems);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaypalCheckoutView(
                          sandboxMode: true,
                          clientId: paypalClientId,
                          secretKey: paypalSecretKey,
                          transactions: [
                            {
                              "amount": {
                                "total": total,
                                "currency": "USD",
                                "details": {
                                  "subtotal": total,
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description": "Fruit Salad Order",
                              "item_list": {
                                "items": items,
                              }
                            }
                          ],
                          note: "Thanks for your order!",
                          onSuccess: (Map params) async {
                            await storeOrder(
                              clientName: widget.clientName,
                              items: cartItems,
                              paymentMethod: selectedMethod,
                            );
                            cartCubit.clearCart();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const OrderSuccessPage()),
                            );
                          },
                          onError: (error) {
                            print("onError: $error");
                            Navigator.pop(context);
                          },
                          onCancel: () {
                            print('cancelled:');
                          },
                        ),
                      ),
                    );
                  } else if (selectedMethod == 'Stripe') {
                    await handleStripePayment(cartItems);
                    await storeOrder(
                      clientName: widget.clientName,
                      items: cartItems,
                      paymentMethod: selectedMethod,
                    );
                    cartCubit.clearCart();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const OrderSuccessPage()),
                    );
                  } else {
                    await storeOrder(
                      clientName: widget.clientName,
                      items: cartItems,
                      paymentMethod: selectedMethod,
                    );
                    cartCubit.clearCart();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const OrderSuccessPage()),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text('Place Order'),
            )
          ],
        ),
      ),
    );
  }
}
