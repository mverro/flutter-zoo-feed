import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_feed/common/utils/coloors.dart';
import 'package:http/http.dart' as http;
import 'package:zoo_feed/common/widgets/custom_elevated_button.dart';
import 'package:zoo_feed/features/auth/pages/login_page.dart';
import 'package:zoo_feed/features/page_controller.dart';
import 'package:zoo_feed/features/home/widgets/profile_menu.dart';
import 'package:zoo_feed/features/user/pages/user_edit_page.dart';
import 'package:zoo_feed/features/user/pages/user_history_page.dart';
import 'package:zoo_feed/features/user/pages/user_liked_page.dart';
import 'package:zoo_feed/features/user/pages/user_ticket_page.dart';

import '../../user/widgets/animal_liked_item.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> users = {};
  List<Map<String, dynamic>> animalsLiked = [];
  bool isLoading = true;

  Future<void> getUser() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      users = json.decode(pref.getString('user_data')!);
    });
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future getAnimalLiked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      final url = Uri.parse('http://13.55.144.244:3000/api/animaluser/info');

      final response =
          await http.get(url, headers: {'access_token': accessToken!});

      if (response.statusCode == 200) {
        List data = (json.decode(response.body)
            as Map<String, dynamic>)['resultUA']['animals'];
        setState(() {
          data.forEach((element) {
            animalsLiked.add(element);
          });
        });
        isLoading = false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future refresh() async {
    animalsLiked.clear();
    users.clear();
    getUser();
    getAnimalLiked();
  }

  @override
  void initState() {
    getUser();
    getAnimalLiked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget profileHeader() {
      return SafeArea(
          child: users.isNotEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height * 1 / 3,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                'http://13.55.144.244:3000/${users['imageUrl']}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/icon/user.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -1,
                            right: 1,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Coloors.green,
                              ),
                              child: Center(
                                child: IconButton(
                                  color: Colors.amber,
                                  tooltip: 'Edit profile',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserEditPage(
                                          users: users,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        users['name'],
                        style: const TextStyle(
                          fontSize: 35,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        users['roleId'] == 1 ? 'Visitor' : 'Zookeeper',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Coloors.gray,
                        ),
                      )
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ));
    }

    Widget logoutMenu() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 22,
            width: 22,
            child: Image.asset(
              'assets/icon/sign-out-alt.png',
              color: Colors.red.shade500,
            ),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 18,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.shade500,
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('CONFIRM'),
                    content: const Text('are you sure to logout?'),
                    actions: [
                      CustomElevatedButton(
                        onPressed: logout,
                        text: 'Yes',
                        isOutline: true,
                        buttonWidth: 60,
                      ),
                      CustomElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        text: 'No',
                        isOutline: false,
                        buttonWidth: 60,
                      ),
                    ],
                  );
                });
          },
        ),
      );
    }

    Widget animalLiked() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.only(bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            // header text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Animals Liked',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                animalsLiked.isNotEmpty
                    ? TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserLikedPage(),
                            ),
                          );
                        },
                        child: const Text('See all'),
                      )
                    : const SizedBox()
              ],
            ),
            // content
            SizedBox(
              height: 90,
              child: animalsLiked.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: animalsLiked.length,
                      itemBuilder: (context, index) {
                        return AnimalLikedItem(
                          image: animalsLiked[index]['imageUrl'],
                          name: animalsLiked[index]['name'],
                        );
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No liked animals.'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(),
                              ),
                            );
                          },
                          child: const Text("Explore more"),
                        ),
                      ],
                    ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Stack(
          children: [
            ListView(
              children: [
                Column(
                  children: [
                    profileHeader(),
                    animalLiked(),
                    // profile menu
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProfileMenu(
                            title: 'Your tickets',
                            icon: 'assets/icon/ticket.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserTicketPage(),
                                ),
                              );
                            },
                          ),
                          ProfileMenu(
                            title: 'Payments History',
                            icon: 'assets/icon/time-past.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserHistoryPage(),
                                ),
                              );
                            },
                          ),
                          logoutMenu(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
