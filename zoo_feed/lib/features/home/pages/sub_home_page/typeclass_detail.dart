import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zoo_feed/features/home/pages/sub_home_page/animal_detail.dart';
import '../../../../common/utils/coloors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_feed/common/widgets/custom_small_card.dart';
import 'package:zoo_feed/common/widgets/custom_headline_animation.dart';

class TypeClassDetailPage extends StatefulWidget {
  final int typeId;

  const TypeClassDetailPage({required this.typeId});

  @override
  State<TypeClassDetailPage> createState() => _TypeClassDetailPageState();
}

class _TypeClassDetailPageState extends State<TypeClassDetailPage> {
  dynamic classDetail;
  dynamic users;
  List<dynamic> animals = [];

  @override
  void initState() {
    getclassDetail();
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    final pref = await SharedPreferences.getInstance();
    final userData = pref.getString('user_data');
    if (userData != null) {
      setState(() {
        users = jsonDecode(userData);
      });
    }
  }

  Future<void> getclassDetail() async {
    final response = await http.get(Uri.parse(
        'http://13.55.144.244:3000/api/classtypes/detail/${widget.typeId}'));
    if (response.statusCode == 200) {
      setState(() {
        classDetail = json.decode(response.body);
        if (classDetail['animals'] != null) {
          setState(() {
            animals = classDetail['animals'];
          });
        }
      });
    } else {
      throw Exception('Failed to fetch animal detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (classDetail == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 285,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                ),
                backgroundColor: Colors.transparent,
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
                floating: true,
                pinned: false,
                snap: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final top = constraints.biggest.height;
                    return Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: top - 150,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Coloors.green,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(37),
                                bottomRight: Radius.circular(37),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: top / 3.5,
                          left: -10,
                          right: 20,
                          child: Card(
                            elevation: 8,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(37),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(37),
                              child: Container(
                                height: 200,
                                color: Colors.transparent,
                                child: Image(
                                  image: NetworkImage(
                                    'http://13.55.144.244:3000/' +
                                        classDetail['imageUrl'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      width: 250,
                      child: Center(
                        child: Text(
                          classDetail['name'],
                          style: const TextStyle(
                            fontSize: 25,
                            fontFamily: 'inter',
                            color: Coloors.green,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 350,
                      child: Text(
                        '${classDetail['description']}',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'inter',
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 350,
                      child: const Center(
                        child: Text(
                          'Corresponding Animals',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'inter',
                            color: Coloors.green,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Row(
                          children: [
                            if (animals.isEmpty)
                              const Text(
                                'No animals were found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            else
                              for (var animal in animals)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AnimalDetailPage(
                                            animalId: animal['id']),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: smallcard(
                                        imageUrl: animal['imageUrl'],
                                        text: '',
                                        destext: animal['name']),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
