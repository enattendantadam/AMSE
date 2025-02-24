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

class Comic {
  final int id;
  final String image;
  final String coverDate;
  final String deck;
  final String description;
  final String name;
  final String htmlraw;

  Comic(
      {required this.id,
      this.image = defaultUrl,
      this.coverDate = "2003-06-14",
      this.deck = "",
      this.description = "failed to load the description",
      this.name = "failed to load name",
      this.htmlraw = "failed to load the description"});

  factory Comic.fromJson(Map<String, dynamic> json) {
    try {
      return Comic(
          id: json['id'],
          image: json['image'],
          coverDate: json['cover_date'],
          deck: json['deck'] ?? "",
          description: json['n_description'] ?? "no desc",
          name: json['name'] ?? "no name",
          htmlraw: json["description"]);
    } catch (e) {
      print("Error converting JSON to Comic: $e");
      print("Problematic JSON: ${jsonEncode(json)}");

      return Comic(
        // Return a default Game object on error
        id: 0,
        name: "Error Loading comic",
        description: "Error loading comic details.",
      );
    }
  }
}

class ComicVineService {
  ComicVineService();

  Future<List<Comic>> getComics() async {
    final url = Uri.parse('https://menade.me/api/comics');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => Comic.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comics: ${response.statusCode}');
    }
  }
}

class Movie {
  final String image;
  final String title;
  final String year;
  final String runtime;
  final String genre;
  final String metaScore;
  final String overview;
  final String director;
  final List<String> stars;

  Movie({
    this.image = defaultUrl,
    this.title = "default title",
    this.year = "N/A",
    this.runtime = "N/A",
    this.genre = "N/A",
    this.metaScore = "N/A",
    this.overview = "N/A",
    this.director = "N/A",
    this.stars = const ["N/A"],
  });

  // Factory constructor to create a Movie from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    try {
      return Movie(
        image: json['image'].replaceAll(
                "._V1_UX67_CR0,0,67,98_AL_", "._V1_SY500_CR0,0,333,500_") ??
            defaultUrl,
        title: json['title'] ?? 'Unknown Title',
        year: json['year'] ?? 'Unknown Year',
        runtime: json['runtime'] ?? 'Unknown Runtime',
        genre: json['genre'] ?? 'Unknown Genre',
        metaScore: json['meta_score'] ?? 'N/A',
        overview: json['overview'] ?? 'No overview available.',
        director: json['director'] ?? 'Unknown Director',
        stars: List<String>.from(json['stars'] ?? []),
      );
    } catch (e) {
      print("Error converting JSON to Movie: $e");
      print("Problematic JSON: ${jsonEncode(json)}");

      // Return a default Movie object on error
      return Movie(
        image:
            "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTfE_qrYMBZ_JB8om-34WGaZARhpX26yWRttqIDvn4_7l--UzX8mxKcPrc59IcvTpEA_G8gPA",
        title: 'Batman the dark knight',
        year: '2008',
        runtime: '152 min',
        genre: 'best',
        metaScore: '100',
        overview:
            'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        director: 'Christopher Nolan',
        stars: [
          "Christian Bale",
          "Heath Ledger",
          "Aaron Eckhart",
          "Michael Caine"
        ],
      );
    }
  }
}

class ImdbService {
  ImdbService();

  Future<List<Movie>> getComics() async {
    final url = Uri.parse('https://menade.me/api/movies');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comics: ${response.statusCode}');
    }
  }
}
