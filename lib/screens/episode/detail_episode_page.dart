import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/constants/api.dart';
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/screens/login_register.dart';
import 'package:rick_and_morty/service/auth.dart';
import 'package:rick_and_morty/widgets/card_character.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rick_and_morty/service/firestore_service.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
FirestoreService firestoreService = FirestoreService();

final user = Auth().getUserEmail();

class DetailEpisode extends StatefulWidget {
  final Episode episode;
  const DetailEpisode({super.key, required this.episode});

  @override
  State<DetailEpisode> createState() => _DetailEpisodeState();
}

class _DetailEpisodeState extends State<DetailEpisode> {
  late Episode episode;
  late var episodeImg1 = 'assets/images/episodemainimg1.jpg';
  late var episodeImg2 = 'assets/images/episodemainimg2.jpg';

  late List<CharacterModel> characterList;
  int ccount = 0;

  @override
  void initState() {
    super.initState();
    episode = widget.episode;
    characterList = [];
    getEpisode(episode.id);
    fetchCommentCount(episode.id.toString());
  }

  void fetchCommentCount(String episodeID) async {
    int commentCount = await firestoreService.getCommentCount(episodeID);
    setState(() {
      ccount = commentCount;
    });
    print('Bu bölümde toplam $commentCount yorum var.');
  }

  Future getEpisode(int episodeId) async {
    fetchCommentCount(episodeId.toString());
    try {
      var response = await Dio().get("${EndPoint.episode.ep}$episodeId");

      if (response.statusCode == 200) {
        setState(() {
          episode = Episode.fromMap(response.data);
        });
        characterList = [];
        for (final characterUrl in episode.characters) {
          await getCharacter(characterUrl);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getCharacter(url) async {
    var response = await Dio().get(url);
    CharacterModel character;
    if (response.statusCode == 200) {
      setState(() {
        character = CharacterModel.fromMap(response.data);
        characterList.add(character);
      });
    }
  }

  String getTimeDif(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);
    if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else {
      int months = (difference.inDays / 30).floor();
      return '${months}m';
    }
  }

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 39, 78, 108),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                //opacity: 0.7,
                alignment: Alignment.topCenter,
                repeat: ImageRepeat.repeat,
                fit: BoxFit.contain,
                image: AssetImage(
                    (episode.id % 4 == 0) ? episodeImg2 : episodeImg1))),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10))),
              //alignment: Alignment.bottomRight,
              padding: const EdgeInsets.fromLTRB(0, 40, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_auth.currentUser == null) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              width: 200,
                              height: 100,
                              child: Column(children: [
                                const Text("login or register"),
                                TextButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginRegisterPAge()))
                                          .whenComplete(() {
                                        setState(() {});

                                        Navigator.pop(context);
                                      });
                                      setState(() {});
                                    },
                                    child: const Text('register'))
                              ]),
                            );
                          },
                        );
                      } else {
                        setState(() {});
                        FirestoreService().addFavorite(
                            _auth.currentUser!.uid.toString(),
                            episode.id.toString(),
                            episode.name);
                      }
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 4,
              child: Container(
                //color: Colors.amber,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.0,
                        0.0,
                        0.5
                      ],
                      colors: [
                        Color.fromARGB(20, 2, 123, 253),
                        Color.fromARGB(129, 40, 66, 122),
                        Color.fromARGB(255, 17, 40, 57),
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  //color: Color.fromARGB(205, 39, 78, 108),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text("${episode.id.toString()} ",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 32,
                                    fontFamily: "Chakra",
                                    shadows: [
                                      Shadow(
                                          blurRadius: 30,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          offset: Offset(3, 2)),
                                      Shadow(
                                          blurRadius: 30,
                                          color:
                                              Color.fromARGB(255, 25, 17, 93),
                                          offset: Offset(3, 2))
                                    ])),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.topCenter,
                            child: AutoSizeText(episode.name,
                                maxLines: 2,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 32,
                                    fontFamily: "Chakra",
                                    shadows: [
                                      Shadow(
                                          blurRadius: 30,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          offset: Offset(3, 2)),
                                      Shadow(
                                          blurRadius: 30,
                                          color:
                                              Color.fromARGB(255, 25, 17, 93),
                                          offset: Offset(3, 2))
                                    ])),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 10,
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Episode',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: "Chakra",
                                )),
                            Text(episode.episode,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 18,
                                  fontFamily: "Chakra",
                                )),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: "Chakra",
                              ),
                            ),
                            Text(episode.airDate,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 18,
                                    fontFamily: "Chakra",
                                    shadows: const [
                                      Shadow(
                                          blurRadius: 10,
                                          color:
                                              Color.fromARGB(186, 24, 17, 93),
                                          offset: Offset(3, 2))
                                    ])),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3))),
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  commentBottomSheet(context);
                                  fetchCommentCount(episode.id.toString());
                                },
                                child: const Text(
                                  'Comments',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: "Chakra",
                                  ),
                                ),
                              ),
                              Text(ccount.toString(),
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 18,
                                      fontFamily: "Chakra",
                                      shadows: const [
                                        Shadow(
                                            blurRadius: 10,
                                            color:
                                                Color.fromARGB(186, 24, 17, 93),
                                            offset: Offset(3, 2))
                                      ])),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      height: 10,
                      color: Colors.grey,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text('Characters',
                          style: TextStyle(color: Colors.white, fontSize: 24)),
                    ),
                    SizedBox(
                      height: 180,
                      child: characterList.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.amber,
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var item = characterList[index];
                                return CharacterCard(character: item);
                              },
                              itemCount: characterList.length),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.grey.withOpacity(0.2))),
                            onPressed: () {
                              getEpisode(episode.id - 1);
                            },
                            child: const Icon(Icons.arrow_back_ios)),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white.withOpacity(0.4))),
                            onPressed: () {
                              getEpisode(episode.id + 1);
                            },
                            child: const Icon(Icons.arrow_forward_ios)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> commentBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              // width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
                    child:
                        const Text("Comments", style: TextStyle(fontSize: 20)),
                  ),
                  const Divider(
                    color: Colors.grey,
                    endIndent: 10,
                    indent: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: StreamBuilder(
                      stream:
                          FirestoreService().getComments(episode.id.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Veriler yüklenirken hata oluştu.'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('no comment find.'));
                        }
                        return ListView(
                          padding: EdgeInsets.all(0),
                          children: snapshot.data!.map((doc) {
                            Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;
                            String comment = data['comment'] ?? '';
                            String userID = data['name'] ?? '';
                            Timestamp timestamp =
                                data['timestamp'] ?? Timestamp.now();

                            return ListTile(
                              title: Text(comment),
                              subtitle:
                                  Text('$userID, ${getTimeDif(timestamp)}'),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    endIndent: 10,
                    indent: 10,
                  ),
                  (_auth.currentUser == null)
                      ? Text('yorum yapmak icin giris yap')
                      : Container(
                          padding: const EdgeInsets.all(8),
                          //height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                width: 300,
                                child: TextField(
                                  controller: _commentController,
                                  decoration: const InputDecoration(
                                      filled: true,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      hintText: "add comment "),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    FirestoreService().addComment(
                                        episode.id.toString(),
                                        _auth.currentUser!.email.toString(),
                                        _auth.currentUser!.uid,
                                        _commentController.text);
                                    FocusScope.of(context).unfocus();
                                    _commentController.clear();
                                    setState(() {
                                      fetchCommentCount(episode.id.toString());
                                    });

                                    //Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.send))
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        );
      },
      isDismissible:
          true, // BottomSheet dışına tıklandığında kapanmasını sağlar
    );
  }
}
