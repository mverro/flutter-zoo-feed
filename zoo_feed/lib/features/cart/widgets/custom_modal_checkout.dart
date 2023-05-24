import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class custom_modal_checkout extends StatefulWidget {
  final num totalPrice;
  final dynamic checkedData;

  const custom_modal_checkout({
    super.key,
    required this.totalPrice,
    required this.checkedData,
  });

  @override
  State<custom_modal_checkout> createState() => _custom_modal_checkoutState();
}

class _custom_modal_checkoutState extends State<custom_modal_checkout> {
  void checkout() async {
    print(widget.checkedData);
    final url = Uri.parse('http://192.168.2.4:3000/api/order/create');
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    Map<String, String> headers = {
      'access_token': accessToken!,
      "Content-Type": "application/json"
    };
    String jsonBody = await jsonEncode(widget.checkedData);
    print(jsonBody);
    final response = await http.post(url, headers: headers, body: jsonBody);
    if (response.statusCode == 200) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Order Success, please pay the order!',
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong ${response.statusCode}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 80,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: const EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total Price: ${formatCurrency.format(widget.totalPrice)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Tambahkan logika untuk melakukan order
                      checkout();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        side: BorderSide(color: Colors.green),
                        backgroundColor: Colors.green),
                    child: Text(
                      'Order',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        side: BorderSide(color: Colors.red),
                        backgroundColor: Colors.red),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 50,
            child: Icon(
              Icons.shopping_cart,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
