import 'package:flutter/material.dart';
import 'package:rick_and_morty/characters_temp.dart';
import 'package:rick_and_morty/screens/character/list_characters_page.dart';
import 'package:rick_and_morty/screens/episode/list_episodes_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'characters_temp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: Scaffold(
      body: GetAndShowCharacters(),
    ),
  ));
}
