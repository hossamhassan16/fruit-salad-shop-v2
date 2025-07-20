import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruite_salad_shop/cubits/cart_cubit/cart_cubit_cubit.dart';
import 'package:fruite_salad_shop/views/map_view.dart';
import 'package:fruite_salad_shop/widgets/checkout_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class MyBasketPage extends StatefulWidget {
  const MyBasketPage({super.key, required this.clientName});
  final String clientName;

  @override
  State<MyBasketPage> createState() => _MyBasketPageState();
}

class _MyBasketPageState extends State<MyBasketPage> {
  LatLng? selectedLocation;
  String? selectedAddress;

  Future<void> _selectLocation() async {
    // انتقل إلى صفحة الخريطة واحصل على الإحداثيات
    final LatLng? location = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapView()),
    );

    if (location != null) {
      // عند العودة من الخريطة نقوم بتحويل الإحداثيات إلى عنوان
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final address =
              '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
          setState(() {
            selectedLocation = location;
            selectedAddress = address;
          });
        } else {
          setState(() {
            selectedLocation = location;
            selectedAddress = 'Unknown location';
          });
        }
      } catch (e) {
        setState(() {
          selectedLocation = location;
          selectedAddress = 'Error fetching address';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('My Basket')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your basket is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.asset(item.item.image, width: 50),
                          title: Text(item.item.name),
                          subtitle: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  context
                                      .read<CartCubit>()
                                      .decrementItem(item.item);
                                },
                              ),
                              Text('${item.quantity}',
                                  style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  context.read<CartCubit>().addItem(item.item);
                                },
                              ),
                            ],
                          ),
                          trailing: Text(
                            '\$${(item.item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Location Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: _selectLocation,
                    icon: const Icon(Icons.location_on),
                    label: Text(selectedAddress == null
                        ? 'Select Delivery Location'
                        : selectedAddress!),
                  ),
                ),

                // Checkout
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${context.read<CartCubit>().totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: selectedLocation == null
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckoutPage(
                                      clientName: widget.clientName,
                                      confirmedLocation: selectedLocation,
                                    ),
                                  ),
                                );
                              },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
