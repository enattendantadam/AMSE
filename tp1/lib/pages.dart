import 'package:flutter/material.dart';
import '../sectionItems.dart';

class SectionPage extends StatelessWidget {
  final String title;

  SectionPage({super.key, required this.title});

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
