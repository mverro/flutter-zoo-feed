import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_feed/features/cart/widgets/payment_card.dart';
import 'package:zoo_feed/common/widgets/costom_skeleton_widget.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late List<dynamic> order;
  bool isLoading = true;

  Future<void> getOrder() async {
    final url = Uri.parse('http://13.55.144.244:3000/api/payment/user');
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    Map<String, String> headers = {'access_token': accessToken!};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        order = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch order');
    }
  }

  Future refresh() async {
    order.clear();
    getOrder();
  }

  @override
  void initState() {
    getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return buildLoadingSkeleton();
    } else {
      final filteredOrder =
          order.where((item) => item['status'] == false).toList();
      if (filteredOrder.isEmpty) {
        return const Scaffold(
          body: Center(
            child: Text('No Items to payment'),
          ),
        );
      } else {
        return Scaffold(
            body: RefreshIndicator(
                onRefresh: refresh,
                child: OrderList(orderList: filteredOrder)));
      }
    }
  }
}
