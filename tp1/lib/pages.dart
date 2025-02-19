import 'package:flutter/material.dart';
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
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Prevents swiping
        children: [
          SectionPage(title: "Movies"),
          SectionPage(title: "TV Shows"),
          SectionPage(title: "Documentaries"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Shows'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fiber_dvr), label: 'Documentaries'),
        ],
      ),
    );
  }
}

class SectionPage extends StatelessWidget {
  final String title;

  SectionPage({super.key, required this.title});

  final List<MediaItem> mediaItems = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Implement refresh functionality here
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
