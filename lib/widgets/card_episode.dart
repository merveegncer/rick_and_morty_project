import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/screens/episode/detail_episode_page.dart';
import 'package:rick_and_morty/screens/character/list_characters_page.dart';

class EpisodeCard extends StatelessWidget {
  final Episode thisEpisode;

  EpisodeCard({
    super.key,
    required this.thisEpisode,
  });

  @override
  Widget build(BuildContext context) {
    var imageurl1 = 'assets/images/episodeimg1.jpg';
    var imageurl2 = 'assets/images/episodeimg2.jpg';
    var imageurl3 = 'assets/images/episodeimg3.jpg';
    var imageurl4 = 'assets/images/episodeimg4.jpg';
    var imageurl5 = 'assets/images/episodeimg5.jpg';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoModalPopupRoute(
          builder: (context) => DetailEpisode(
            episode: thisEpisode,
          ),
        ));
      },
      child: Column(
        children: [
          Container(
            height: 150,

            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.none,
                    scale: 2.2,
                    opacity: 0.8,
                    image: AssetImage(thisEpisode.id % 6 == 0
                        ? imageurl1
                        : (thisEpisode.id % 6 == 1
                            ? imageurl2
                            : (thisEpisode.id % 6 == 2
                                ? imageurl3
                                : (thisEpisode.id % 6 == 3
                                    ? imageurl4
                                    : imageurl1))))),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                    transform: const GradientRotation(6),
                    colors: [
                      const Color.fromARGB(255, 63, 143, 205).withOpacity(0.2),
                      const Color.fromARGB(255, 92, 254, 151).withOpacity(0.2),
                    ])),
            //color: Colors.black.withOpacity(0.5),
            margin: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(thisEpisode.episode,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 30)),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.shade900.withOpacity(0.5),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(16),
                                  right: Radius.circular(4))),
                          child: AutoSizeText(
                            thisEpisode.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            maxLines: 2,
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
    );
  }
}
