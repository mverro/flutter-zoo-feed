import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_feed/features/ticket/ticket_page.dart';

import '../../../common/utils/coloors.dart';

class UserTicketPage extends StatefulWidget {
  const UserTicketPage({super.key});

  @override
  State<UserTicketPage> createState() => _UserTicketPageState();
}

class _UserTicketPageState extends State<UserTicketPage> {
  List<dynamic> tickets = [];

  Future getTickets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      final url = Uri.parse('http://13.55.144.244:3000/api/userTicket/user');

      final response = await http.get(
        url,
        headers: {'access_token': accessToken!},
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        setState(() {
          tickets = res.where((item) => item['status'] == false).toList();
        });
        print(tickets);
      }
    } catch (e) {
      print(e);
    }
  }

  Future refresh() async {
    tickets.clear();
    getTickets();
  }

  @override
  void initState() {
    getTickets();
    super.initState();
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
          "Ticket",
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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: GridView.builder(
          padding: const EdgeInsets.all(15.0),
          itemCount: tickets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 7 / 8,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 1 / 3,
                        width: MediaQuery.of(context).size.width * 3 / 4,
                        child: Image.network(
                          'http://13.55.144.244:3000/${tickets[index]['barcode']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20.0, // Soften the shaodw
                      spreadRadius: 2.0,
                      offset: Offset(0.0, 0.0),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15.0),
                          bottom: Radius.circular(15.0)),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.network(
                          'http://13.55.144.244:3000/${tickets[index]['barcode']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('ID ${tickets[index]['id']}'),
                          Text(
                            tickets[index]['ticketType']['category'],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
