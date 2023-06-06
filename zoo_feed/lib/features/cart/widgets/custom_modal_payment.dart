import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:quickalert/quickalert.dart';

class custom_modal_payment extends StatefulWidget {
  final int totalPrice;
  final int orderId;

  const custom_modal_payment({
    Key? key,
    required this.totalPrice,
    required this.orderId,
  }) : super(key: key);

  @override
  State<custom_modal_payment> createState() => _custom_modal_paymentState();
}

class _custom_modal_paymentState extends State<custom_modal_payment> {
  String? selectedMethodPayment;

  void payment() async {
    if (selectedMethodPayment == null) {
      await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Please select a payment method');
      return;
    }
    final url = Uri.parse('http://13.55.144.244:3000/api/payment/update');
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    Map<String, String> headers = {
      'access_token': accessToken!,
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: {
          'orderId': widget.orderId.toString(),
          'method': selectedMethodPayment,
        },
      );

      if (response.statusCode == 200) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Payment successful',
        );
      }
    } catch (error) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong ${error}',
      );
    }
  }

  void showDialogLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Loading'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Uploading your data'),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
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
              const Text(
                'Total Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total Price: ${formatCurrency.format(widget.totalPrice)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Method Payment',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                value: selectedMethodPayment,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMethodPayment = newValue;
                  });
                },
                items: <String>[
                  'Paypal',
                  'OVO',
                  'Gopay',
                  'Virtual Account Bank'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      payment();
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
                        side: const BorderSide(color: Colors.green),
                        backgroundColor: Colors.green),
                    child: const Text(
                      'Pay',
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
                        side: const BorderSide(color: Colors.red),
                        backgroundColor: Colors.red),
                    child: const Text(
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
        const Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 50,
            child: Icon(
              Icons.payment,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
