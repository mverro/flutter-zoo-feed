import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zoo_feed/common/utils/coloors.dart';

import '../../home/pages/sub_home_page/animal_detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = '';
  List<dynamic> animals = [];

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

  @override
  void initState() {
    getAnimals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget searchCard(Map<String, dynamic> animal) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimalDetailPage(animalId: animal['id']),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.amber,
                  image: DecorationImage(
                      image: NetworkImage(
                        'http://13.55.144.244:3000/${animal['imageUrl']}',
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                animal['name'],
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Coloors.green,
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: animals.length,
        itemBuilder: (context, index) {
          if (name.isEmpty) {
            return const SizedBox();
          }
          if (animals[index]['name']
              .toString()
              .toLowerCase()
              .startsWith(name.toLowerCase())) {
            return searchCard(animals[index]);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
