import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/coloors.dart';

class HistoryCard extends StatelessWidget {
  final String name;
  final String type;
  final int qty;
  final int price;
  final String? image;
  const HistoryCard({
    super.key,
    required this.name,
    required this.type,
    required this.qty,
    required this.price,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 1 / 5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              // image
              Container(
                width: MediaQuery.of(context).size.width * 1 / 5,
                height: MediaQuery.of(context).size.width * 1 / 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: image != null
                        ? DecorationImage(
                            image: NetworkImage(
                                'http://13.55.144.244:3000/$image'),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage(
                              type == 'Regular'
                                  ? 'assets/img/ticket_regular.png'
                                  : 'assets/img/ticket_vip.png',
                            ),
                            fit: BoxFit.cover,
                          )),
              ),
              const SizedBox(
                width: 10,
              ),
              // produk info
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  // kuantitas & harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$qty x ',
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
                        ).format(price),
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
            ],
          ),
          Divider(
            thickness: 2,
            color: Colors.grey.shade200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub Total',
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
                ).format(qty * price),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Coloors.green,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}
