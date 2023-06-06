import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:zoo_feed/features/home/pages/sub_home_page/animal_detail.dart';

class AnimalPage extends StatefulWidget {
  @override
  _AnimalPageState createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  List<dynamic> animals = [];
  List<dynamic> animalsLiked = [];

  Future<void> getAnimals() async {
    final response =
        await http.get(Uri.parse('http://13.55.144.244:3000/api/animals/'));
    if (response.statusCode == 200) {
      setState(() {
        animals = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to fetch animals');
    }
  }

  void navigateToAnimalDetail(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetailPage(animalId: id),
      ),
    );
  }

  Future like(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url = Uri.parse('http://13.55.144.244:3000/api/animaluser/add');
    final response = await http.post(
      url,
      headers: {
        'access_token': accessToken!,
      },
      body: {
        'animalId': '$id',
      },
    );

    if (response.statusCode == 200) {
      animalsLiked.clear();
      getLikedAnimals();
    }
  }

  Future unLike(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url =
        Uri.parse('http://13.55.144.244:3000/api/animaluser/delete/$id');
    final response = await http.delete(url, headers: {
      'access_token': accessToken!,
    });

    if (response.statusCode == 200) {
      animalsLiked.clear();
      getLikedAnimals();
    }
  }

  Future getLikedAnimals() async {
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

  @override
  void initState() {
    getLikedAnimals();
    getAnimals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: animals.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          final animal = animals[index];
          return GestureDetector(
            onTap: () {
              navigateToAnimalDetail(animal['id']);
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
                          'http://13.55.144.244:3000/${animal['imageUrl']}',
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
                                animal['name'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                animal['classType']['name'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                      animalsLiked
                              .where((element) => element['id'] == animal['id'])
                              .isEmpty
                          ? Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.favorite_border),
                                color: Colors.white,
                                onPressed: () {
                                  like(animal['id']);
                                },
                              ),
                            )
                          : Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red.shade300,
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  unLike(animal['id']);
                                },
                              ),
                            )
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
