import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/coloors.dart';
import '../widgets/history_card.dart';

class DetailHistoryPage extends StatelessWidget {
  final List<dynamic> items;
  final Map datas;
  const DetailHistoryPage(
      {super.key, required this.items, required this.datas});

  String encryptText(String text) {
    // var bytes = utf8.encode(text);
    var digest = sha1.convert([int.parse(text)]);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
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
          "Detail Payment History",
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return items[index]['food'].isNotEmpty
                      ? HistoryCard(
                          name: items[index]['food'][0]['name'],
                          price: items[index]['food'][0]['price'],
                          qty: items[index]['qty'],
                          type: items[index]['food'][0]['type'],
                          image: items[index]['food'][0]['imageUrl'],
                        )
                      : HistoryCard(
                          name: 'Ticket',
                          price: items[index]['tickets'][0]['ticketType']
                              ['price'],
                          qty: items[index]['qty'],
                          type: items[index]['tickets'][0]['ticketType']
                              ['category'],
                        );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      encryptText(datas['id'].toString()),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      datas['updatedAt'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      datas['method'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(datas['total']),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Coloors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
