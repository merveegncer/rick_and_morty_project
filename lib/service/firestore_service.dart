import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rick_and_morty/screens/episode/detail_episode_page.dart';
import 'package:rick_and_morty/service/auth.dart';

class FirestoreService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference episodesCollection =
      FirebaseFirestore.instance.collection('episodes');

  Stream<List<DocumentSnapshot>> getFavoriteEpisodes(String userId) {
    return usersCollection
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<int> getCommentCount(String episodeID) async {
    QuerySnapshot commentsSnapshot =
        await episodesCollection.doc(episodeID).collection('comments').get();

    return commentsSnapshot.size;
  }

  Stream<List<DocumentSnapshot>> getComments(String episodeID) {
    return episodesCollection
        .doc(episodeID)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> addFavorite(
      String userID, String episodeID, String title) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(userID)
        .collection('favorites')
        .doc(episodeID)
        .set({
          'title': title,
          'addedAt': FieldValue.serverTimestamp(),
        })
        .then((value) => print("Favorite Added"))
        .catchError((error) => print("Failed to add favorite: $error"));
  }

  Future<void> addComment(
    String episodeID,
    String userEmail,
    String userID,
    String comment,
  ) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    String? name = userDoc['name'] ?? 'unknow';

    await episodesCollection
        .doc(episodeID)
        .collection('comments')
        .doc(userEmail)
        .set({
          'userID': userID,
          'comment': comment,
          'timestamp': FieldValue.serverTimestamp(),
          'name': name
        })
        .then((value) => print("comment added"))
        .catchError((error) => print("failed to add comment: $error"));
  }
}
