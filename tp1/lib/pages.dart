import 'package:flutter/material.dart';
import 'package:tp1/utils.dart';
import '../sectionItems.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  MainPage({super.key, this.initialIndex = 0});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(ImageDataManager().getCategoryNames());
    return Scaffold(
      body: PageView(
        controller: _pageController, // Prevents swiping
        children: [
          MoviePage(),
          VideoGamePage(),
          SectionPage(title: ImageDataManager().getCategoryNames()[3]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'TV Shows'),
          BottomNavigationBarItem(
              icon: Icon(Icons.movie), label: 'Documentaries'),
        ],
      ),
    );
  }
}

class SectionPage extends StatefulWidget {
  final String title;

  const SectionPage({super.key, required this.title});

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  List<MediaItem> mediaItems = []; // Initialize as empty

  @override
  void initState() {
    super.initState();
    _initializeMediaItems(); // Call initialization method
  }

  void _initializeMediaItems() {
    // This method should be overridden in subclasses
    mediaItems = [
      MediaItem(
        title: "Example Item 1",
        description: "A thrilling adventure about...",
        imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
      ),
      MediaItem(
        title: "Example Item 2",
        description: "A fascinating drama about...",
        imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _initializeMediaItems(); // Call initialization method on refresh
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          return MediaItemWidget(mediaItem: mediaItems[index]);
        },
      ),
    );
  }
}

class VideoGamePage extends SectionPage {
  VideoGamePage({super.key}) : super(title: "Video Games");

  @override
  _VideoGamePageState createState() => _VideoGamePageState();
}

class _VideoGamePageState extends _SectionPageState {
  @override
  void _initializeMediaItems() {
    mediaItems = [
      MediaItem(
        title: "Example VG 1",
        description: "A thrilling adventure about...",
        imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
      ),
      MediaItem(
        title: "Example VG 2",
        description: "A fascinating drama about...",
        imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
      ),
      // Add more video game items here
    ];
  }
}

class MoviePage extends SectionPage {
  MoviePage({super.key}) : super(title: "Movies");

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends _SectionPageState {
  @override
  void _initializeMediaItems() {
    mediaItems = [
      MediaItem(
        title: "Example movie 1",
        description: "A thrilling adventure about...",
        imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
      ),
      MediaItem(
        title: "Example movie 2",
        description: "A fascinating drama about...",
        imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
      ),
      // Add more video game items here
    ];
  }
}
