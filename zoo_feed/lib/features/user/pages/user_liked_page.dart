import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/utils/coloors.dart';
import '../../home/pages/sub_home_page/animal_detail.dart';

class UserLikedPage extends StatefulWidget {
  const UserLikedPage({super.key});

  @override
  State<UserLikedPage> createState() => _UserLikedPageState();
}

class _UserLikedPageState extends State<UserLikedPage> {
  List<Map<String, dynamic>> animalsLiked = [];

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
      }
    } catch (e) {
      print(e);
    }
  }

  Future unLike(id) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url =
        Uri.parse('http://13.55.144.244:3000/api/animaluser/delete/$id');
    final response = await http.delete(url, headers: {
      'access_token': accessToken!,
    });

    if (response.statusCode == 200) {
      animalsLiked.clear();
      getAnimalLiked();
    }
  }

  @override
  void initState() {
    getAnimalLiked();
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
        title: const Text(
          "Animal Liked",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "inter",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: animalsLiked.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnimalDetailPage(animalId: animalsLiked[index]['id']),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 30.0,
              shadowColor: Colors.black,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15.0),
                            bottom: Radius.circular(15.0)),
                        child: Image.network(
                          'http://13.55.144.244:3000/${animalsLiked[index]['imageUrl']}',
                          fit: BoxFit.cover,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                animalsLiked[index]['name'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Colors.white,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text('Unlike this animal?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        unLike(animalsLiked[index]['id']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: Colors.red.shade500),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
