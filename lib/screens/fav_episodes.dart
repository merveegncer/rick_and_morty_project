import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rick_and_morty/models/episode_model.dart';
import 'package:rick_and_morty/screens/episode/detail_episode_page.dart';
import 'package:rick_and_morty/screens/login_register.dart';

import 'package:rick_and_morty/service/auth.dart';

import 'package:rick_and_morty/service/firestore_service.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirestoreService _firestoreService = FirestoreService();
  late List<Episode> episodeList;
  late Episode episode;

  Future<void> getSingleEpisode(a) async {
    var response =
        await Dio().get('https://rickandmortyapi.com/api/episode/$a');
    if (response.statusCode == 200) {
      setState(() {
        episode = Episode.fromMap(response.data);
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => DetailEpisode(episode: episode)));
        debugPrint(response.statusCode.toString());
      });
    }
    debugPrint(response.statusMessage);
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String userId = user!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Bölümler'),
      ),
      body: Column(
        children: [
          Text(user.email.toString()),
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _firestoreService.getFavoriteEpisodes(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Veriler yüklenirken hata oluştu.'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Favori bölüm bulunamadı.'));
                }

                return ListView(
                  children: snapshot.data!.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    String episodeID = doc.id;
                    String title = data['title'] ?? '';

                    return ListTile(
                      title: Text(title),
                      subtitle: Text('Episode ID: $episodeID'),
                      onTap: () async {
                        getSingleEpisode(episodeID);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Auth().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginRegisterPAge()),
                );
              },
              child: const Text("log out"))
        ],
      ),
    );
  }
}
