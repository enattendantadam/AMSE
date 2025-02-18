import 'package:flutter/material.dart';
import '../sectionItems.dart';

class SectionPage extends StatefulWidget {
  final String title;

  const SectionPage({super.key, required this.title});

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  final PageController _pageController = PageController();

  final List<MediaItem> mediaItems = [
    MediaItem(
      title: "Example Movie 1",
      description: "A thrilling adventure about...",
      imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
    ),
    MediaItem(
      title: "Example Movie 2",
      description: "A fascinating drama about...",
      imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
    ),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print("refresh");
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          ListView.builder(
            itemCount: mediaItems.length,
            itemBuilder: (context, index) {
              return MediaItemWidget(mediaItem: mediaItems[index]);
            },
          ),
          ListView.builder(
            itemCount: mediaItems.length,
            itemBuilder: (context, index) {
              return MediaItemWidget(mediaItem: mediaItems[index]);
            },
          ),
          ListView.builder(
            itemCount: mediaItems.length,
            itemBuilder: (context, index) {
              return MediaItemWidget(mediaItem: mediaItems[index]);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'TV Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_dvr),
            label: 'Documentaries',
          ),
        ],
      ),
    );
  }
}
