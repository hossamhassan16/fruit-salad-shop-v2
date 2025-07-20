import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  final String clientName;

  const OrderHistoryPage({super.key, required this.clientName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(clientName)
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(child: Text("No orders found."));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final timestamp = (data['timestamp'] as Timestamp).toDate();
              final formattedTime =
                  "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}";

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("Total: \$${data['totalPrice']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment: ${data['paymentMethod']}"),
                      Text("Date: $formattedTime"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
