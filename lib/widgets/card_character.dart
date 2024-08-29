import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character_model.dart';

import '../screens/character/detail_character_page.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;

  const CharacterCard({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoModalPopupRoute(
          builder: (context) => DetailPage(
            theCharacter: character,
          ),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient:
                LinearGradient(transform: const GradientRotation(4), colors: [
              const Color.fromARGB(255, 63, 143, 205).withOpacity(0.2),
              const Color.fromARGB(255, 92, 254, 151).withOpacity(0.2),
            ])),
        //color: Colors.black.withOpacity(0.5),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: Image(image: NetworkImage(character.image))),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AutoSizeText(
                character.name,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      /*  child: Card(
        margin: const EdgeInsets.fromLTRB(10, 8, 8, 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 3,
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                Container(
                  child: Image.network(character.image),
                ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.topLeft,
              child:
                  Text(character.name, style: TextStyle(color: Colors.white)),
            ),
            /*  Chip(
              labelStyle: TextStyle(fontSize: 12),
              label: Text(character.species.name),
            ), */
          ],
        ),
      ), */
    );
  }
}
