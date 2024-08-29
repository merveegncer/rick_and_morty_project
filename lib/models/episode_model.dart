import 'package:meta/meta.dart';
import 'dart:convert';

class Episode {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characters;
  final String url;
  final DateTime created;

  Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });

  factory Episode.fromJson(String str) => Episode.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Episode.fromMap(Map<String, dynamic> json) => Episode(
        id: json["id"] ?? 2,
        name: json["name"] ?? '',
        airDate: json["air_date"] ?? "",
        episode: json["episode"] ?? "",
        characters:
            List<String>.from(json["characters"].map((x) => x)) ?? ['a'],
        url: json["url"] ?? "",
        created: DateTime.parse(json["created"] ?? ''),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "air_date": airDate,
        "episode": episode,
        "characters": List<dynamic>.from(characters.map((x) => x)),
        "url": url,
        "created": created.toIso8601String(),
      };
}
