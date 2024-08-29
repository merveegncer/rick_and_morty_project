import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/screens/episode/detail_episode_page.dart';
import 'package:rick_and_morty/widgets/card_episode.dart';
import 'package:rick_and_morty/widgets/green_text.dart';
import 'package:expandable/expandable.dart';

class DetailPage extends StatefulWidget {
  final CharacterModel theCharacter;

  const DetailPage({Key? key, required this.theCharacter}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Episode> episodeList;
  late CharacterModel _character;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    episodeList = [];
    String searchName = "";

    _character = widget.theCharacter;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 13),
    );
    _controller.forward();

    for (var a in _character.episode) {
      getSingleEpisode(a);
    }
  }

  Future<void> getSingleEpisode(a) async {
    var response = await Dio().get(a);
    Episode episode;
    if (response.statusCode == 200) {
      setState(() {
        episode = Episode.fromMap(response.data);
        episodeList.add(episode);

        debugPrint(response.statusCode.toString());
      });
    }
    debugPrint(response.statusMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 64, 64, 64),
            image: DecorationImage(
                scale: 0.1,
                repeat: ImageRepeat.repeatY,
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
                opacity: 0.5,
                image: AssetImage('assets/images/detailBackground.jpg'))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [topOfPage(context), imagePortalStack()],
        ),
      ),
    );
  }

  Container topOfPage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 10),
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        color: Color.fromARGB(149, 140, 181, 221),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          Text(
            "# ${_character.id}",
            style: const TextStyle(
                fontSize: 35,
                fontFamily: "Chakra",
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                      blurRadius: 10,
                      color: Color.fromARGB(186, 24, 17, 93),
                      offset: Offset(3, 2))
                ]),
          ),
          const Expanded(child: SizedBox(width: 100)),
          Container(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Chip(
                    label: Text(_character.status.name,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0))),
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Chip(label: Text(_character.species.name)),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Expanded imagePortalStack() {
    return Expanded(
      child: Stack(
        children: [
          Align(alignment: Alignment.bottomCenter, child: character_info()),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                  width: 10,
                ),
                Container(
                    height: 210,
                    width: 210,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(200)),
                      child: Image.network(_character.image, fit: BoxFit.fill),
                    )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.3).animate(_controller),
              child: Container(
                  height: 250,
                  width: 250,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(200)),
                      child: Image.asset('assets/images/portal.png'))),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 300),
                  height: 120,
                  width: 120,
                  child: Image.asset('assets/images/portalGun.png')))
        ],
      ),
    );
  }

  Container character_info() {
    return Container(
      padding: const EdgeInsets.only(top: 80),
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Color.fromARGB(255, 8, 54, 2),
                offset: Offset(1, 1),
                blurStyle: BlurStyle.outer)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Color.fromARGB(149, 140, 181, 221)),
      height: 550,
      width: 410,
      child: Column(
        children: [
          nameHeader(), //header and gender chip
          Expanded(child: liste()) // list of character info and episode list
        ],
      ),
    );
  }

  Container nameHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                height: 50,
                alignment: Alignment.centerLeft,
                child: GreenText(
                  text: _character.name,
                  size: 40.0,
                )),
          ),
          Container(
            width: 118,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topRight,
            child: Chip(
                avatar: const Icon(
                  Icons.female,
                  size: 22,
                ),
                side: const BorderSide(
                    color: Color.fromARGB(60, 0, 0, 0), width: 2),
                label: Text(_character.gender.name,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 253, 227, 255),
                        shadows: [
                          Shadow(
                              blurRadius: 6,
                              color: Color.fromARGB(125, 0, 0, 0),
                              offset: Offset(2, 2)),
                          Shadow(
                              blurRadius: 6,
                              color: Color.fromARGB(121, 0, 0, 0),
                              offset: Offset(1, 3))
                        ])),
                backgroundColor: (_character.gender.name.toString() == 'MALE')
                    ? Colors.blue
                    : const Color.fromARGB(255, 216, 11, 117)),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView liste() {
    return SingleChildScrollView(
      controller: _scrollController,
      primary: false,
      child: Column(
        children: [
          info_row('Name', _character.name, 2, 3),
          info_row('Status', _character.status.name, 2, 3),
          episodeListTileWidget(),
          info_row('Species', _character.species.name, 2, 3),
          info_row('Gender', _character.gender.name, 2, 3),
          info_row('Location', _character.location.name.toString(), 2, 3),
          info_row('Type', _character.type, 2, 3),
        ],
      ),
    );
  }

  Container episodeListTileWidget() {
    return Container(
      child: ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        dense: true,
        horizontalTitleGap: 0,
        minVerticalPadding: 0,
        child: ExpansionTile(
          onExpansionChanged: (value) {
            if (value) {
              _scrollController.animateTo(
                100.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            } else {
              _scrollController.animateTo(
                -1.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            }
          },
          controlAffinity: ListTileControlAffinity.platform,
          tilePadding: const EdgeInsets.only(right: 8),
          title: info_row('Episodes ', episodeList.length.toString(), 2, 1),
          children: [
            Container(
                padding: const EdgeInsets.all(0),
                child: getepisodes(_character)),
          ],
        ),
      ),
    );
  }

  Container info_row(String txt, String inf, int f1, f2) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(9),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color.fromARGB(170, 7, 28, 72),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: Color.fromARGB(255, 8, 3, 69),
              offset: Offset(0, 0),
              blurStyle: BlurStyle.outer,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: f1,
            child: AutoSizeText(
              textAlign: TextAlign.start,
              maxLines: 2,
              style: const TextStyle(
                  shadows: [
                    Shadow(
                        blurRadius: 10,
                        color: Color.fromARGB(0, 3, 19, 57),
                        offset: Offset(-3, 0)),
                    Shadow(
                        blurRadius: 8,
                        color: Color.fromARGB(0, 7, 4, 59),
                        offset: Offset(-1, 1))
                  ],
                  fontSize: 30,
                  color: Color.fromARGB(255, 160, 104, 220),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Chakra'),
              "  ${txt} :",
            ),
          ),
          Expanded(
            flex: f2,
            child: AutoSizeText(
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                    shadows: [
                      Shadow(
                          blurRadius: 8,
                          color: Color.fromARGB(0, 7, 4, 59),
                          offset: Offset(-1, 1))
                    ],
                    fontFamily: 'Chakra',
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 255, 255)),
                inf),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Container getepisodes(CharacterModel character) {
    var imageurl;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: character.episode.length,
        itemBuilder: (context, index) {
          if (episodeList[index].id % 5 == 0) {
            imageurl = 'assets/images/episodeimg1.jpg';
          } else if (episodeList[index].id % 5 == 1) {
            imageurl = 'assets/images/episodeimg2.jpg';
          } else if (episodeList[index].id % 5 == 2) {
            imageurl = 'assets/images/episodeimg3.jpg';
          } else if (episodeList[index].id % 5 == 3) {
            imageurl = 'assets/images/episodeimg4.jpg';
          } else {
            imageurl = 'assets/images/episodeimg5.jpg';
          }
          return Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 5),
            margin: const EdgeInsets.fromLTRB(8, 0, 60, 6),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white30,
            ),
            child: ListTile(
                isThreeLine: false,
                dense: true,
                onTap: () {
                  Episode episode = episodeList[index];
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => DetailEpisode(episode: episode)));
                },
                leading: Container(
                  margin: EdgeInsets.only(right: 10),
                  //  padding: EdgeInsets.all(10),
                  child: Image(
                    image: AssetImage(imageurl),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                title: Text(
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                    episodeList[index].episode.toString()),
                subtitle: AutoSizeText(
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    episodeList[index].name)),
          );
        },
      ),
    );
  }
}
