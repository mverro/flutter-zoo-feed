import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoo_feed/common/utils/coloors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_feed/common/widgets/costom_loading_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zoo_feed/features/ticket/widgets/custom_modal_ticket_buy.dart';
import 'widgets/ticket_card.dart';
import 'package:zoo_feed/common/widgets/custom_headline_animation.dart';

class TicketPage extends StatefulWidget {
  TicketPage({Key? key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  late List<dynamic> tickets;
  dynamic users;
  bool isUserDataLoaded = false;
  bool isTicketDataLoaded = false;

  Future<void> getUserData() async {
    final pref = await SharedPreferences.getInstance();
    final userData = pref.getString('user_data');
    if (userData != null) {
      setState(() {
        users = jsonDecode(userData);
        isUserDataLoaded = true;
      });
    }
  }

  Future<void> getTicketData() async {
    final url = Uri.parse("http://13.55.144.244:3000/api/ticket/");
    final response = await http.get(url);
    setState(() {
      tickets = json.decode(response.body);
      isTicketDataLoaded = true;
    });
  }

  Future refresh() async {
    tickets.clear();
    getTicketData();
  }

  @override
  void initState() {
    getUserData();
    getTicketData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserDataLoaded || !isTicketDataLoaded) {
      return LoadingScreen();
    } else {
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
                      'http://13.55.144.244:3000/${users['imageUrl']}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ModalTicketBuy(
                            destext: tickets[index]['ticketType']['category'],
                            stock: tickets[index]['stock'],
                            price: tickets[index]['ticketType']['price'],
                            ticketId: tickets[index]['id'],
                          );
                        },
                      );
                    },
                    child: TicketCard(
                      ticketType: tickets[index]['ticketType']['category'],
                      price: tickets[index]['ticketType']['price'],
                      image: tickets[index]['ticketTypeId'] == 1
                          ? 'assets/img/ticket_regular.png'
                          : 'assets/img/ticket_vip.png',
                    ),
                  );
                },
              )),
        ),
      );
    }
  }
}
