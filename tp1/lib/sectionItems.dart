import 'package:flutter/material.dart';
import './utils.dart';

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
    Widget detailPage;
    switch (mediaItem.runtimeType) {
      case ComicItem:
        detailPage = ComicDetailPage(mediaItem: mediaItem as ComicItem);
        break;
      //case MovieItem:
      //  detailPage = MovieDetailPage(mediaItem: mediaItem as MovieItem);
      //  break;
      //case GameItem:
      //  detailPage = GameDetailPage(mediaItem: mediaItem as GameItem);
      //  break;
      default:
        detailPage = DetailPage(mediaItem: mediaItem);
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => detailPage,
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
              child: Image.network(
                  mediaItem.imageUrl.replaceAll("t_thumb", "t_cover_big"),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                mediaItem.imageUrl.replaceAll("t_thumb", "t_cover_big"),
                width: 264,
                height: 352,
              ),
              const SizedBox(height: 10),
              Text(mediaItem.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(mediaItem.description, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

String formatHtmlContent(String htmlContent) {
  // Remove links but keep the link text
  final RegExp linkExp = RegExp(r'<a[^>]*>(.*?)<\/a>');
  htmlContent =
      htmlContent.replaceAllMapped(linkExp, (match) => match.group(1) ?? '');

  // Replace <strong> and <b> with bold text
  htmlContent = htmlContent.replaceAll(RegExp(r'<(strong|b)>'), '<b>');
  htmlContent = htmlContent.replaceAll(RegExp(r'</(strong|b)>'), '</b>');

  // Replace <em> and <i> with italic text
  htmlContent = htmlContent.replaceAll(RegExp(r'<(em|i)>'), '<i>');
  htmlContent = htmlContent.replaceAll(RegExp(r'</(em|i)>'), '</i>');

  // Remove all remaining HTML tags, but keep the text formatting
  final RegExp exp = RegExp(r'<[^>]+>');
  htmlContent = htmlContent.replaceAll(exp, '');

  return htmlContent;
}

class ComicItem extends MediaItem {
  final String releaseDate;
  final String htmlDescription;

  ComicItem({
    required super.title,
    required super.description,
    required super.imageUrl,
    required this.releaseDate,
    required this.htmlDescription,
  });
}

class ComicDetailPage extends StatelessWidget {
  final ComicItem mediaItem;

  const ComicDetailPage({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mediaItem.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image section
              Image.network(
                mediaItem.imageUrl.replaceAll("square_avatar", "scale_small"),
                width: 264,
                height: 352,
              ),
              const SizedBox(height: 10),

              Text(
                mediaItem.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text(
                formatHtmlContent(mediaItem.htmlDescription),
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              Text(
                "Release Date: ${mediaItem.releaseDate}",
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
