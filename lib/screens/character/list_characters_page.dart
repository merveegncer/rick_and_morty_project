import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/constants/api.dart';
import 'package:rick_and_morty/constants/constants.dart';
import 'package:rick_and_morty/screens/episode/detail_episode_page.dart';
import 'package:rick_and_morty/screens/episode/list_episodes_page.dart';
import 'package:rick_and_morty/screens/fav_episodes.dart';
import 'package:rick_and_morty/screens/login_register.dart';
import 'package:rick_and_morty/widgets/green_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rick_and_morty/service/firestore_service.dart';

// episode karakter listesi yuklenmesi, episode kapak gorsel cesitliligi

import '../../models/character_model.dart';
import '../../widgets/card_character.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class GetAndShowCharacters extends StatefulWidget {
  const GetAndShowCharacters({super.key});

  @override
  State<GetAndShowCharacters> createState() => _GetAndShowCharacterState();
}

class _GetAndShowCharacterState extends State<GetAndShowCharacters> {
  TextEditingController textEditingController = TextEditingController();

  final Dio _dio = Dio();
  String _nextPageUrl = "https://rickandmortyapi.com/api/character";
  String _previousPageUrl = "https://rickandmortyapi.com/api/character/?page=1";

  Map filter = {};

  var gridcount = 2;
  var pageNum = 0;
  bool isLoading = false;

  List<CharacterModel> characterList = [];

  Future<void> getCharacters(String url) async {
    debugPrint('heyy');
    debugPrint(url);

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(url);
      final data = response.data;
      debugPrint(url);

      if (response.statusCode == 200) {
        setState(() {
          characterList = [];
          for (var a in data['results']) {
            var character = CharacterModel.fromMap(a);
            characterList.add(character);
          }

          _nextPageUrl = data['info']['next'] ??
              "https://rickandmortyapi.com/api/character/?page=42";
          _previousPageUrl = data['info']['prev'] ??
              "https://rickandmortyapi.com/api/character/?page=1";
        });
        debugPrint(url);
      } else {
        debugPrint('noo');
      }
    } on Dio catch (e) {
      debugPrint(url);

      debugPrint('Error fetching characters: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  search() {
    String filterParameters = "";
    String filteredUrl;
    filter.forEach((key, value) {
      filterParameters = "$filterParameters&$key=$value";
    });
    filteredUrl = "${EndPoint.character.ep}?${filterParameters.substring(1)}";
    getCharacters(filteredUrl);
  }

  @override
  void initState() {
    super.initState();
    getCharacters(_nextPageUrl);
    pageNum = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 24, 100),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          opacity: 0.6,
          fit: BoxFit.cover,
          image: AssetImage('assets/images/homebackgroung.jpg'),
        )),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 32),
                child: const Image(
                  height: 100,
                  image: AssetImage('assets/images/RickMortyBaslik.png'),
                ),
              ),
              Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.only(left: 8),
                    margin: const EdgeInsets.all(8),
                    child: TextField(
                      decoration: const InputDecoration(
                          filled: true,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          icon: Icon(Icons.search),
                          hintText: 'Search Character'),
                      controller: textEditingController,
                      onSubmitted: (value) {
                        setState(
                          () {
                            filter["name"] = textEditingController.text;
                          },
                        );
                        search();
                      },
                    ),
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white.withOpacity(0.5))),
                            onPressed: () {
                              setState(() {
                                filter["status"] = "alive";
                              });
                              search();
                            },
                            child: const Text("alive")),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.grey.withOpacity(0.3))),
                            onPressed: () {
                              setState(() {
                                filter["status"] = "dead";
                              });
                              search();
                            },
                            child: const Text("dead")),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        color: Colors.white.withOpacity(0.6),
                        onPressed: pageNum > 1
                            ? () {
                                if (!isLoading) {
                                  getCharacters(_previousPageUrl);
                                  setState(() {
                                    pageNum--;
                                  });
                                }
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Text("$pageNum ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white70)),
                      const Text("/42",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white38)),
                      IconButton(
                        color: Colors.white.withOpacity(0.6),
                        onPressed: pageNum < 42
                            ? () {
                                if (!isLoading) {
                                  getCharacters(_nextPageUrl);
                                  setState(() {
                                    pageNum++;
                                  });
                                }
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: charaterGridList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const GetAndShowEpisodes()));
                    },
                    icon: Icon(Icons.home),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_auth.currentUser == null) {
                        print('nulll kulalnivi ');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginRegisterPAge()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoritesPage()));
                      }
                    },
                    icon: Icon(Icons.person),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      /* bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(205, 8, 3, 69),
          onTap: (value) {},
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Characters',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Episodes',
            ),
          ],
        ),
      ), */
    );
  }

  Widget charaterGridList() {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: characterList.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        var character = characterList[index];
        return CharacterCard(character: character);
      },
    );
  }
}
