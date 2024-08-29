import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/widgets/card_episode.dart';
import 'package:rick_and_morty/widgets/green_text.dart';

class CharactersTemp extends StatefulWidget {
  const CharactersTemp({super.key});

  @override
  State<CharactersTemp> createState() => _CharactersTempState();
}

class _CharactersTempState extends State<CharactersTemp> {
  final Dio _dio = Dio();
  String url = 'https://rickandmortyapi.com/api/character/1';
  CharacterModel? _character;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getEpisodes('https://rickandmortyapi.com/api/episode');
  }

  var pageNum = 0;
  bool isLoading = false;
  var seasonList = [];
  var imageurl;

  late List<Episode> s1 = [];
  late List<Episode> s2 = [];
  late List<Episode> s3 = [];
  late List<Episode> s4 = [];
  late List<Episode> s5 = [];

  List<Episode> _episodeList = [];

  Future<void> getEpisodes(url) async {
    debugPrint(url);

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });
    try {
      for (var i = 1; i < 4; i++) {
        final response = await Dio().get(url + '?page=$i');
        final data = response.data;

        if (response.statusCode == 200) {
          debugPrint(response.statusMessage);
          setState(() {
            _episodeList = (response.data["results"] as List)
                .map((e) => Episode.fromMap(e))
                .toList();
          });

          var results = data['results'] as List;
          print(results.first['episode']);

          var episodesContainingS01 = (data['results'] as List)
              .where((episode) => episode['episode'].contains('S01'))
              .map((e) => Episode.fromMap(e))
              .toList();
          s1.addAll(episodesContainingS01);

          var episodesContainingS02 = (data['results'] as List)
              .where((episode) =>
                  episode['episode'] != null &&
                  episode['episode'].contains('S02'))
              .map((e) => Episode.fromMap(e))
              .toList();
          s2.addAll(episodesContainingS02);

          var episodesContainingS03 = (data['results'] as List)
              .where((episode) =>
                  episode['episode'] != null &&
                  episode['episode'].contains('S03'))
              .map((e) => Episode.fromMap(e))
              .toList();
          s3.addAll(episodesContainingS03);

          var episodesContainingS04 = (data['results'] as List)
              .where((episode) =>
                  episode['episode'] != null &&
                  episode['episode'].contains('S04'))
              .map((e) => Episode.fromMap(e))
              .toList();
          s4.addAll(episodesContainingS04);

          var episodesContainingS05 = (data['results'] as List)
              .where((episode) =>
                  episode['episode'] != null &&
                  episode['episode'].contains('S05'))
              .map((e) => Episode.fromMap(e))
              .toList();
          s5.addAll(episodesContainingS05);
        } else
          debugPrint(response.statusMessage);
      }
    } catch (e) {
      debugPrint('Error fetching episodes: $e');
    }

    setState(() {
      isLoading = false;
    });
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
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(10, 50, 0, 10),
                child: const Text('Episodes',
                    style: TextStyle(fontSize: 50, color: Colors.white)),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                  // controller: textEditingController,
                  onSubmitted: (value) {
                    setState(
                      () {
                        // filter["name"] = textEditingController.text;
                      },
                    );
                    //  search();
                  },
                ),
              ),
              Container(
                height: 50, // Adjust the height according to your needs

                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seasonList = s1;
                          });
                        },
                        child: const Text('season1')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seasonList = s2;
                          });
                        },
                        child: const Text('season2')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seasonList = s3;
                          });
                        },
                        child: const Text('season3')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seasonList = s4;
                          });
                        },
                        child: const Text('season4')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            seasonList = s5;
                          });
                        },
                        child: const Text('season5'))
                  ],
                ),
              ),
              Expanded(
                child: seasonList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.amber,
                        ),
                      )
                    : ListView.builder(
                        itemCount: seasonList.length,
                        itemBuilder: (context, index) {
                          var character = seasonList[index];
                          return EpisodeCard(thisEpisode: seasonList[index]);
                        },
                      ),
              )
            ])));
  }
}
