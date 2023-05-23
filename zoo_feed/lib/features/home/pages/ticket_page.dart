import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoo_feed/common/utils/coloors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zoo_feed/common/widgets/custom_modal_ticket_buy.dart';
import '../widgets/ticket_card.dart';
import 'package:zoo_feed/common/widgets/custom_headline_animation.dart';

class TicketPage extends StatefulWidget {
  TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  List<dynamic>? tickets = [];
  dynamic users;

  Future<void> getUserData() async {
    final pref = await SharedPreferences.getInstance();
    final userData = pref.getString('user_data');
    if (userData != null) {
      setState(() {
        users = jsonDecode(userData);
      });
    }
  }

  Future getTicket() async {
    final url = Uri.parse("http://192.168.1.6:3000/api/ticket/");
    final response = await http.get(url);
    setState(() {
      tickets = json.decode(response.body);
    });
  }

  @override
  void initState() {
    getTicket();
    getUserData();
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
        title: AnimatedTitleWidget(
          username: users!['name'],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'http://192.168.1.6:3000/${users!['imageUrl']}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            itemCount: tickets!.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ModalTicketBuy(
                          destext: tickets![index]['ticketType']['category'],
                          stock: tickets![index]['stock'],
                          price: tickets![index]['ticketType']['price'],
                          ticketId: tickets![index]['id']);
                    },
                  );
                },
                child: TicketCard(
                  ticketType: tickets![index]['ticketType']['category'],
                  price: tickets![index]['ticketType']['price'],
                  image: 'assets/img/ticket_regular.png',
                ),
              );
            },
          )),
    );
  }
}
