import 'package:flutter/material.dart';
import '../sectionItems.dart';

class SectionPage extends StatefulWidget {
  final String title;

  const SectionPage({super.key, required this.title});

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  int _selectedIndex = 0;

  final List<MediaItem> mediaItems = [
    MediaItem(
      title: "Example Movie",
      description: "A thrilling adventure about...",
      imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
    ),
    MediaItem(
      title: "Another Show",
      description: "A fascinating drama about...",
      imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
    ),
    // Add more items here
  ];

  final List<Widget> _pages = [
    SectionPage(title: 'Movies'),
    SectionPage(title: 'TV Shows'),
    SectionPage(title: 'Documentaries'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.title), backgroundColor: Colors.deepPurple),
      body: ListView.builder(
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          return MediaItemWidget(mediaItem: mediaItems[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'TV Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Documentaries',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your refresh logic here
          setState(() {});
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
