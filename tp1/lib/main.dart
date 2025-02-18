import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../pages.dart';

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
    print("AAAA");
    final String response = await rootBundle.loadString('assets/info.json');
    print(response.length);
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
    print("AZE");
    // renvoie la ième JsonItem d'une page
    var images = _imageData[page];
    if (images != null && index >= 0 && index < images.length) {
      return images[index];
    }
    return JsonItem.defaultItem(); // Out of range = null
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("🔄 Calling loadJson...");
  await ImageDataManager().loadJson(); // ✅ Ensures JSON is loaded
  print("✅ JSON Loaded, running app...");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Home Menu',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Added theme color
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white, // Text color
          ),
        ),
      ),
      home: const HomeMenu(),
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Menu'),
        backgroundColor: Colors.deepPurple, // Match theme
      ),
      body: Center(
        child: ListView(
          children: [
            MenuButton(
              title: ImageDataManager().getImage("home", 0).title,
              imageUrl: ImageDataManager().getImage("home", 0).url,
              destination: SectionPage(
                  title: ImageDataManager().getImage("home", 0).title),
            ),
            MenuButton(
              title: ImageDataManager().getImage("home", 1).title,
              imageUrl: ImageDataManager().getImage("home", 1).url,
              destination: PlaceholderPage(
                  title: ImageDataManager().getImage("home", 1).title),
            ),
            MenuButton(
              title: ImageDataManager().getImage("home", 2).title,
              imageUrl: ImageDataManager().getImage("home", 2).url,
              destination: PlaceholderPage(
                  title: ImageDataManager().getImage("home", 2).title),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple, // Match theme
      ),
      body: const Center(
        child: Text('This is a placeholder page'),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Widget destination;

  const MenuButton(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.destination});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 100, // Adjust button height
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.deepPurple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => destination));
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(imageUrl,
                    width: 100, height: 100, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionPage extends StatelessWidget {
  final String title;

  SectionPage({super.key, required this.title});

  final List<MediaItem> mediaItems = [
    MediaItem(
      title: "Example Movie",
      description: "A thrilling adventure about...",
      imageUrl: "https://via.placeholder.com/100",
    ),
    MediaItem(
      title: "Another Show",
      description: "A fascinating drama about...",
      imageUrl: "https://via.placeholder.com/100",
    ),
    // Add more items here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.deepPurple),
      body: ListView.builder(
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          return MediaItemWidget(mediaItem: mediaItems[index]);
        },
      ),
    );
  }
}

class MediaItem {
  final String title;
  final String description;
  final String imageUrl;

  MediaItem(
      {required this.title, required this.description, required this.imageUrl});
}

class MediaItemWidget extends StatelessWidget {
  final MediaItem mediaItem;

  const MediaItemWidget({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(mediaItem: mediaItem),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(mediaItem.imageUrl,
                  width: 100, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mediaItem.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(mediaItem.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final MediaItem mediaItem;

  const DetailPage({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(mediaItem.title), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(mediaItem.imageUrl),
            const SizedBox(height: 10),
            Text(mediaItem.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(mediaItem.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
