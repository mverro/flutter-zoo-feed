import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zoo_feed/common/widgets/costom_loading_screen.dart';
import 'dart:convert';
import 'package:zoo_feed/features/cart/widgets/cart_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import 'package:zoo_feed/features/cart/widgets/custom_modal_checkout.dart';
import 'package:zoo_feed/common/widgets/costom_skeleton_widget.dart';

class CartDetailPage extends StatefulWidget {
  const CartDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartDetailPage> createState() => _CartDetailPageState();
}

class _CartDetailPageState extends State<CartDetailPage> {
  late List<dynamic> cart;
  bool isLoading = true;
  List<int> checkedItems = [];

  Future<void> getCart() async {
    final url = Uri.parse('http://13.55.144.244:3000/api/cart/');
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    Map<String, String> headers = {'access_token': accessToken!};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        cart = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  Future<void> deleteCartItem(int cartId) async {
    final url = Uri.parse('http://13.55.144.244:3000/api/cart/delete/$cartId');
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    Map<String, String> headers = {'access_token': accessToken!};

    setState(() {
      cart.removeWhere((item) => item['id'] == cartId);
    });

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        cart.clear();
        getCart();
      }
    } catch (error) {
      throw Exception('Failed to delete item: $error');
    }
  }

  void getCheckedData() async {
    List<Map<String, dynamic>> checkedList = [];
    num totalPrice = 0;

    for (int cartId in checkedItems) {
      final item = cart.firstWhere((element) => element['id'] == cartId);
      checkedList.add({'cartId': item['id']});
    }
    Map<String, List<Map<String, dynamic>>> checkedData = {
      'data': checkedList,
    };

    for (int cartId in checkedItems) {
      final item = cart.firstWhere((element) => element['id'] == cartId);

      if (item['tickets'].isEmpty) {
        totalPrice += item['food'][0]['price'] * item['qty'];
      } else {
        totalPrice += item['tickets'][0]['ticketType']['price'] * item['qty'];
      }
    }

    if (checkedList.isEmpty) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'You must check at least one item',
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return custom_modal_checkout(
              totalPrice: totalPrice, checkedData: checkedData);
        },
      );
    }
  }

  Future<void> updateQty(int cartId, int qty, int isIncrease) async {
    final url = Uri.parse('http://13.55.144.244:3000/api/cart/update');
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    Map<String, String> headers = {'access_token': accessToken!};
    Map<String, String> body = {
      'id': cartId.toString(),
      'qty': qty.toString(),
      'indicator': isIncrease.toString()
    };
    try {
      final response = await http.put(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        cart.clear();
        getCart();
      }
    } catch (error) {
      throw Exception('Failed to update item: $error');
    }
  }

  Future<void> refresh() async {
    cart.clear();
    getCart();
  }

  @override
  void initState() {
    getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return buildLoadingSkeleton();
    } else {
      final filteredCart =
          cart.where((item) => item['status'] == false).toList();
      if (filteredCart.isEmpty) {
        return const Scaffold(
          body: Center(
            child: Text('No Items in your cart'),
          ),
        );
      } else {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: refresh,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView.builder(
                itemCount: filteredCart.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = filteredCart[index];
                  if (item['tickets'].isEmpty) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (_) => deleteCartItem(item['id']),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: CartCard(
                        cartId: item['id'],
                        name: item['food'][0]['name'],
                        price: item['food'][0]['price'],
                        image: item['food'][0]['imageUrl'],
                        qty: item['qty'],
                        stock: item['food'][0]['stock'],
                        isChecked: checkedItems.contains(item['id']),
                        onCheckboxChanged: (isChecked) {
                          setState(() {
                            if (isChecked) {
                              checkedItems.add(item['id']);
                            } else {
                              checkedItems.remove(item['id']);
                            }
                          });
                        },
                        onQtyChanged: (newqty, isIncrease) =>
                            {updateQty(item['id'], newqty, isIncrease)},
                      ),
                    );
                  } else {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (_) => deleteCartItem(item['id']),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: CartCard(
                        cartId: item['id'],
                        name: item['tickets'][0]['ticketType']['category'],
                        price: item['tickets'][0]['ticketType']['price'],
                        image: '',
                        qty: item['qty'],
                        isTicket: true,
                        stock: item['tickets'][0]['stock'],
                        isVip: item['tickets'][0]['ticketTypeId'] == 2,
                        isChecked: checkedItems.contains(item['id']),
                        onCheckboxChanged: (isChecked) {
                          setState(() {
                            if (isChecked) {
                              checkedItems.add(item['id']);
                            } else {
                              checkedItems.remove(item['id']);
                            }
                          });
                        },
                        onQtyChanged: (newqty, isIncrease) =>
                            {updateQty(item['id'], newqty, isIncrease)},
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              getCheckedData();
            },
            backgroundColor: Colors.orange,
            label: const Text('Checkout'),
            icon: const Icon(Icons.shopping_cart),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      }
    }
  }
}
