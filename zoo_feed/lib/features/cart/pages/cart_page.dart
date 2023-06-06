import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../common/utils/coloors.dart';
import 'package:zoo_feed/common/widgets/costom_loading_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_feed/features/cart/pages/sub_cart_page/cart_detail_page.dart';
import 'package:zoo_feed/features/cart/pages/sub_cart_page/payment_page.dart';
import 'package:zoo_feed/common/widgets/custom_headline_animation.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  dynamic users;
  bool isUserDataLoaded = false;
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

  @override
  void initState() {
    getUserData();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserDataLoaded) {
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
            username: users['name'],
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
          bottom: TabBar(
            controller: _tabController,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Coloors.orange,
                width: 8,
              ),
              insets: EdgeInsets.symmetric(horizontal: 30.0),
            ),
            tabs: const [
              Tab(
                text: 'Cart',
                icon: Icon(Icons.shopping_cart),
              ),
              Tab(text: 'Payment', icon: Icon(Icons.payment)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            CartDetailPage(),
            PaymentPage(),
          ],
        ),
      );
    }
  }
}
