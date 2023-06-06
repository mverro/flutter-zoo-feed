import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:zoo_feed/features/cart/widgets/custom_modal_payment.dart';
import '../../../common/utils/coloors.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class OrderList extends StatelessWidget {
  final List<dynamic> orderList;

  OrderList({required this.orderList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        return OrderCard(order: orderList[index]);
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final dynamic order;

  String encryptText(String text) {
    var bytes = utf8.encode(text);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final orderId = order['orderId'];
    final total = order['total'];
    final userName = order['user']['name'];
    final carts = order['order']['carts'];

    List<Widget> items = [];

    for (var cart in carts) {
      if (cart['tickets'].isNotEmpty) {
        final ticketCategory = cart['tickets'][0]['ticketType']['category'];
        items.add(Text(ticketCategory));
      }

      if (cart['food'].isNotEmpty) {
        final foodName = cart['food'][0]['name'];
        items.add(Text(foodName));
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order ID:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              encryptText('${orderId}'),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Total:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              NumberFormat.currency(
                locale: 'id',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(total),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'User Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              '$userName',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Items:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items,
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return custom_modal_payment(
                          totalPrice: total, orderId: orderId);
                    },
                  );
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Coloors.orange),
                child: const Text('Pay Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
