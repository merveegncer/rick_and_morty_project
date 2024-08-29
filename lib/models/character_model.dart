import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:rick_and_morty/models/episode_model.dart';

class CharacterModel {
  final int id;
  final String name;
  final Status status;
  final Species species;
  final String type;
  final Gender gender;
  final Location origin;
  final Location location;
  final String image;
  final List<String> episode;
  final String url;
  final DateTime created;
  Color? _genderColor = Colors.blue;

  getColor() {
    return _genderColor;
  }

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory CharacterModel.fromJson(String str) {
    if (str == null) {
      return CharacterModel(
        id: 0,
        name: '',
        status: Status.UNKNOWN,
        species: Species.HUMAN,
        type: 'UNKNOWN',
        gender: Gender.UNKNOWN,
        origin: Location(name: '', url: ''),
        location: Location(name: '', url: ''),
        image: '',
        episode: [],
        url: '',
        created: DateTime.now(),
      );
    }

    return CharacterModel.fromMap(json.decode(str));
  }

/*   factory CharacterModel.emptymodel() {
    return CharacterModel(
        id: 0,
        name: '',
        status: Status.UNKNOWN,
        species: Species.HUMAN,
        type: '',
        gender: Gender.UNKNOWN,
        origin: Location(name: '', url: ''),
        location: Location(name: '', url: ''),
        image: '',
        episode: [],
        url: '',
        created: DateTime.now());
  }
 */
  String toJson() => json.encode(toMap());

  factory CharacterModel.fromMap(Map<String, dynamic> json) => CharacterModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        status: statusValues.map[json["status"]] ?? Status.UNKNOWN,
        species: speciesValues.map[json["species"]] ?? Species.HUMAN,
        type: json["type"] ?? '',
        gender: genderValues.map[json["gender"]] ?? Gender.UNKNOWN,
        origin: json["origin"] != null
            ? Location.fromMap(json["origin"])
            : Location(name: '', url: ''),
        location: json["location"] != null
            ? Location.fromMap(json["location"])
            : Location(name: '', url: ''),
        image: json["image"] ?? '',
        episode: List<String>.from(json["episode"].map((x) => x)),
        url: json["url"] ?? '',
        created: json["created"] != null
            ? DateTime.parse(json["created"])
            : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "status": statusValues.reverse[status],
        "species": speciesValues.reverse[species],
        "type": type,
        "gender": genderValues.reverse[gender],
        "origin": origin.toMap(),
        "location": location.toMap(),
        "image": image,
        "episode": List<dynamic>.from(episode.map((x) => x)),
        "url": url,
        "created": created.toIso8601String(),
      };
}

enum Gender { FEMALE, MALE, UNKNOWN }

final genderValues = EnumValues(
    {"Female": Gender.FEMALE, "Male": Gender.MALE, "unknown": Gender.UNKNOWN});

class Location {
  final String? name;
  final String? url;

  Location({
    required this.name,
    required this.url,
  });

  factory Location.fromJson(String? str) {
    if (str == null) {
      return Location(name: '', url: '');
    }
    return Location.fromMap(json.decode(str));
  }
  String toJson() => json.encode(toMap());

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        name: json["name"] != null ? json["name"] : '',
        url: json["url"] != null ? json["url"] : '',
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "url": url,
      };
}

enum Species { ALIEN, HUMAN }

final speciesValues =
    EnumValues({"Alien": Species.ALIEN, "Human": Species.HUMAN});

enum Status { ALIVE, DEAD, UNKNOWN }

final statusValues = EnumValues(
    {"Alive": Status.ALIVE, "Dead": Status.DEAD, "unknown": Status.UNKNOWN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
