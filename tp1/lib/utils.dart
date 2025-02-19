import 'dart:convert';
import 'package:flutter/services.dart';

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
