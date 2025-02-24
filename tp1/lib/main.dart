import 'package:flutter/material.dart';
import '../pages.dart';
import '../utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ImageDataManager().loadJson(); // load the json for later
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Home Menu',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        // Use the secondary color from the colorScheme for accent
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.amberAccent),

        // Define custom text styles
        textTheme: TextTheme(
          headlineMedium: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Headline style
          bodyMedium:
              TextStyle(fontSize: 18, color: Colors.white70), // Body style
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),

        // Set scaffold background color
        scaffoldBackgroundColor:
            Colors.grey[900], // Darker background for a modern look
      ),
      home: const HomeMenu(),
    );
  }
}

class HomeMenu extends StatelessWidget {
  //temporary home menu (no return to it)
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randomizer'),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/dice1.jpg'),
          fit: BoxFit.none,
          repeat: ImageRepeat.repeat,
        )),
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              MenuButton(
                title: ImageDataManager().getImage("home", 0).title,
                imageUrl: ImageDataManager().getImage("home", 0).url,
                destination: MainPage(initialIndex: 0),
              ),
              MenuButton(
                title: ImageDataManager().getImage("home", 1).title,
                imageUrl: ImageDataManager().getImage("home", 1).url,
                destination: MainPage(initialIndex: 1),
              ),
              MenuButton(
                title: ImageDataManager().getImage("home", 2).title,
                imageUrl: ImageDataManager().getImage("home", 2).url,
                destination: MainPage(initialIndex: 2),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        color: lighterThemeColor,
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => destination));
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [themeColor, lighterThemeColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image,
                          size: 50, color: Colors.grey);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
