import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../common/utils/coloors.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalTicketBuy extends StatefulWidget {
  final String destext;
  final int stock;
  final dynamic price;
  final int ticketId;

  const ModalTicketBuy({
    required this.destext,
    required this.stock,
    required this.price,
    required this.ticketId,
  });

  @override
  _ModalTicketBuyState createState() => _ModalTicketBuyState();
}

class _ModalTicketBuyState extends State<ModalTicketBuy> {
  int count = 0;

  void incrementCount() {
    setState(() {
      if (count < widget.stock) {
        count++;
      }
    });
  }

  void decrementCount() {
    setState(() {
      if (count > 0) {
        count--;
      }
    });
  }

  void buyTicket() async {
    if (count <= 0) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Must have at least one item',
      );
    } else {
      final url = Uri.parse('http://13.55.144.244:3000/api/cartTicket/create');
      final pref = await SharedPreferences.getInstance();
      final accessToken = pref.getString('access_token');
      Map<String, String> headers = {'access_token': accessToken!};
      final body = {
        'qty': count.toString(),
        'ticketId': widget.ticketId.toString()
      };
      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: '${widget.destext} Ticket added to your cart',
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              '${widget.destext}',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Coloors.orange,
                  fontFamily: 'inter'),
            ),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 200,
              child: Image.asset('assets/img/ticket_regular.png'),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(left: 50),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Stock: ${widget.stock}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Price: ${NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp',
                      ).format(widget.price)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Coloors.green,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                    onPressed: decrementCount,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 80,
                  child: Center(
                    child: Text(
                      'Qty : ' + count.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'inter',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Coloors.green,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: incrementCount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 60,
              width: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Coloors.green,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  buyTicket();
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
