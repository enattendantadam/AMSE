import 'package:flutter/material.dart';

const String shark =
    "https://www.nanarland.com/media/cache/resolve/front_film_single_cover/uploads/films/5e8b565c69467-sharknado-jaquette.jpg";

void main() {
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
              title: 'Page 1',
              imageUrl: shark,
              destination: PlaceholderPage(title: 'Page 1'),
            ),
            MenuButton(
              title: 'Page 2',
              imageUrl: shark,
              destination: PlaceholderPage(title: 'Page 2'),
            ),
            MenuButton(
              title: 'Page 3',
              imageUrl: shark,
              destination: PlaceholderPage(title: 'Page 3'),
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
