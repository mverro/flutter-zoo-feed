import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../common/utils/coloors.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalBuyWidget extends StatefulWidget {
  final String imageUrl;
  final String destext;
  final int stock;
  final dynamic price;
  final int foodId;

  const ModalBuyWidget({
    required this.imageUrl,
    required this.destext,
    required this.stock,
    required this.price,
    required this.foodId,
  });

  @override
  _ModalBuyWidgetState createState() => _ModalBuyWidgetState();
}

class _ModalBuyWidgetState extends State<ModalBuyWidget> {
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

  void buyFood() async {
    if (count <= 0) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Must have at least one item',
      );
    } else {
      final url = Uri.parse('http://13.55.144.244:3000/api/cartfood/create');
      final pref = await SharedPreferences.getInstance();
      final accessToken = pref.getString('access_token');
      Map<String, String> headers = {'access_token': accessToken!};
      final body = {
        'qty': count.toString(),
        'foodId': widget.foodId.toString()
      };

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: '${widget.destext} added to your cart',
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
                  color: Coloors.green,
                  fontFamily: 'inter'),
            ),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFFB983E),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(
                      'http://13.55.144.244:3000/' + widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.only(left: 50),
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
                  const SizedBox(height: 10),
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
                  buyFood();
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
