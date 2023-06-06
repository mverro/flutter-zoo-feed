import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoo_feed/common/widgets/costom_small_button_circle.dart';
import 'package:zoo_feed/common/utils/coloors.dart';

typedef QtyChangedCallback = void Function(int qty, int isIncrease);

class CartCard extends StatefulWidget {
  final String image;
  final String name;
  final int price;
  final int qty;
  final int cartId;
  final bool isTicket;
  final bool isVip;
  final bool isChecked;
  final int stock;
  final ValueChanged<bool> onCheckboxChanged;
  final QtyChangedCallback onQtyChanged;

  CartCard({
    required this.image,
    required this.name,
    required this.price,
    required this.qty,
    required this.cartId,
    this.isTicket = false,
    this.isVip = false,
    required this.isChecked,
    required this.stock,
    required this.onCheckboxChanged,
    required this.onQtyChanged,
  });

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int _qty = 0;
  late int isIncrease;

  @override
  void initState() {
    super.initState();
    _qty = widget.qty;
  }

  void increaseQty() {
    if (widget.stock > 0) {
      setState(() {
        _qty++;
      });
      isIncrease = 1;
      widget.onQtyChanged(_qty, isIncrease);
    }
  }

  void decreaseQty() {
    if (_qty > 1) {
      setState(() {
        _qty--;
      });
      isIncrease = 0;
      widget.onQtyChanged(_qty, isIncrease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Checkbox(
              value: widget.isChecked,
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    widget.onCheckboxChanged(value);
                  });
                }
              },
              activeColor: Coloors.orange,
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Coloors.orange;
                }
                return null;
              }),
            ),
            const SizedBox(width: 10.0),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.isTicket
                      ? AssetImage(widget.isVip
                          ? 'assets/img/ticket_vip.png'
                          : 'assets/img/ticket_regular.png')
                      : NetworkImage(
                              'http://13.55.144.244:3000/' + widget.image)
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(widget.price),
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Max Stock: ${widget.stock}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Row(
              children: [
                CustomSmallButtonCircle(
                  iconData: Icons.remove,
                  onPressed: () {
                    setState(() {
                      decreaseQty();
                    });
                  },
                ),
                const SizedBox(width: 15),
                Text(
                  _qty.toString(),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15),
                CustomSmallButtonCircle(
                  iconData: Icons.add,
                  onPressed: () {
                    setState(() {
                      increaseQty();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
