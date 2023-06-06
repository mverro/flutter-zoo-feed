import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zoo_feed/features/user/pages/detail_history_page.dart';

import '../../../common/utils/coloors.dart';

class UserHistoryPage extends StatefulWidget {
  const UserHistoryPage({super.key});

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {
  List<dynamic> datas = [];

  Future getPayments() async {
    final url = Uri.parse('http://13.55.144.244:3000/api/payment/user');
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    final Map<String, String> headers = {'access_token': accessToken!};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final res = json.decode(response.body);

      setState(() {
        datas = res.where((item) => item['status'] == true).toList();
      });
    } else {
      throw Exception('Failed to fetch order');
    }
  }

  @override
  void initState() {
    getPayments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget card(Map datas) {
      return Container(
        height: MediaQuery.of(context).size.height * 1 / 7,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(datas['total']),
                  style: const TextStyle(
                    color: Coloors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Text(
                  datas['method'],
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              datas['updatedAt'],
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${datas['order']['carts'].length.toString()} Items',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(37),
            bottomRight: Radius.circular(37),
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Coloors.green,
        title: const Text(
          "Payment History",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "inter",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView.builder(
          itemCount: datas.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailHistoryPage(
                    items: datas[index]['order']['carts'],
                    datas: datas[index],
                  ),
                ),
              ),
              child: card(datas[index]),
            );
          },
        ),
      ),
    );
  }
}
