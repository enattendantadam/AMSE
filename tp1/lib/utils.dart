import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String defaultUrl =
    "https://gssc.esa.int/navipedia/images/a/a9/Example.jpg";

class JsonItem {
  // class pour représenter les élements du fichier json
  final String title;
  final String url;
  final String description;

  JsonItem({required this.title, required this.description, required this.url});

  factory JsonItem.defaultItem() {
    return JsonItem(
        title: "default", url: defaultUrl, description: "default description");
  }

  factory JsonItem.fromJson(Map<String, dynamic> json) {
    return JsonItem(
      title: json["title"],
      description: json["description"],
      url: json["url"],
    );
  }
}

class ImageDataManager {
  static final ImageDataManager _instance = ImageDataManager._internal();
  factory ImageDataManager() => _instance;

  ImageDataManager._internal();

  Map<String, List<JsonItem>> _imageData = {};

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString('assets/info.json');
    final Map<String, dynamic> data = jsonDecode(response);

    _imageData = data.map((key, value) {
      return MapEntry(
          key, (value as List).map((item) => JsonItem.fromJson(item)).toList());
    });
  }

  List<JsonItem> getImagesPage(String page) {
    // renvoie la liste de JsonItem d'une page
    return _imageData[page] ?? [];
  }

  JsonItem getImage(String page, int index) {
    // renvoie la ième JsonItem d'une page
    var images = _imageData[page];
    if (images != null && index >= 0 && index < images.length) {
      return images[index];
    }
    return JsonItem.defaultItem(); // si introuvable
  }

  List<String> getCategoryNames() {
    return _imageData.keys.toList();
  }
}

class Game {
  final int id;
  final String coverUrl;
  final String firstReleaseDate;
  final List<String> genres;
  final List<String> involvedCompanies;
  final List<String> keywords;
  final String name;
  final List<String> platforms;
  final List<String> screenshotUrls;
  final List<SimilarGame> similarGames;
  final String summary;
  final String storyline;
  final List<String> themes;
  final double totalRating;
  final int totalRatingCount;

  Game({
    required this.id,
    this.coverUrl = defaultUrl,
    this.firstReleaseDate = "2003-06-14",
    this.genres = const ["N/A"],
    this.involvedCompanies = const ["N/A"],
    this.keywords = const ["N/A"],
    required this.name,
    this.platforms = const ["N/A"],
    this.screenshotUrls = const [],
    this.similarGames = const [],
    this.summary = "",
    this.storyline = "",
    this.themes = const ["N/A"],
    this.totalRating = -1.0,
    this.totalRatingCount = -1,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    try {
      return Game(
        id: json['id'],
        coverUrl: json['cover']?['url'] ?? defaultUrl,
        firstReleaseDate: json['first_release_date'] ?? "",
        genres: json['genres'] != null
            ? List<String>.from(json['genres'])
            : const [],
        involvedCompanies: json['involved_companies'] != null
            ? List<String>.from(
                json['involved_companies'].map((ic) => ic['company_name']))
            : const [],
        keywords: json['keywords'] != null
            ? List<String>.from(json['keywords'])
            : const [],
        name: json['name'],
        platforms: json['platforms'] != null
            ? List<String>.from(json['platforms'])
            : const [],
        screenshotUrls: json['screenshots'] != null
            ? List<String>.from(
                json['screenshots'].map((screenshot) => screenshot['url']))
            : const [],
        similarGames: json['similar_games'] != null
            ? List<SimilarGame>.from(
                json['similar_games'].map((game) => SimilarGame.fromJson(game)))
            : const [],
        summary: json['summary'] ?? "",
        storyline: json['storyline'] ?? "",
        themes: json['themes'] != null
            ? List<String>.from(json['themes'])
            : const [],
        totalRating: json['total_rating']?.toDouble() ?? -1.0,
        totalRatingCount: json['total_rating_count'] ?? 0,
      );
    } catch (e) {
      print("Error converting JSON to Game: $e");
      print("Problematic JSON: ${jsonEncode(json)}");

      return Game(
        // Return a default Game object on error
        id: 0,
        name: "Error Loading Game",
        summary: "Error loading game details.",
      );
    }
  }
}

class SimilarGame {
  final int id;
  final String name;
  final String coverUrl;

  SimilarGame({required this.id, required this.name, this.coverUrl = ""});

  factory SimilarGame.fromJson(Map<String, dynamic> json) {
    return SimilarGame(
      id: json['id'],
      name: json['name'],
      coverUrl: json['cover']?['url'] ?? "",
    );
  }
}

class IgdbService {
  IgdbService();

  Future<List<Game>> getGames() async {
    final url = Uri.parse('https://menade.me/api/videogames');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load games: ${response.statusCode}');
    }
  }
}
