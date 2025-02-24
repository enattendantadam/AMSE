import 'package:flutter/material.dart';
import './utils.dart';
import './pages.dart';

List<MediaItem> favoriteMediaItems = [];

class MediaItem {
  final String title;
  final String description;
  final String imageUrl;

  MediaItem(
      {required this.title, required this.description, required this.imageUrl});
}

class MediaItemWidget extends StatefulWidget {
  final MediaItem mediaItem;

  const MediaItemWidget({super.key, required this.mediaItem});

  @override
  _MediaItemWidgetState createState() => _MediaItemWidgetState();
}

class _MediaItemWidgetState extends State<MediaItemWidget> {
  bool get isFavorite => favoriteMediaNotifier.value.contains(widget.mediaItem);

  void _toggleFavorite() {
    if (isFavorite) {
      favoriteMediaNotifier.value = List.from(favoriteMediaNotifier.value)
        ..remove(widget.mediaItem);
    } else {
      favoriteMediaNotifier.value = List.from(favoriteMediaNotifier.value)
        ..add(widget.mediaItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget detailPage;
    switch (widget.mediaItem.runtimeType) {
      case ComicItem:
        detailPage = ComicDetailPage(mediaItem: widget.mediaItem as ComicItem);
        break;
      case MovieItem:
        detailPage = MovieDetailPage(mediaItem: widget.mediaItem as MovieItem);
        break;
      case GameItem:
        detailPage = GameDetailPage(gameItem: widget.mediaItem as GameItem);
        break;
      default:
        detailPage = DetailPage(mediaItem: widget.mediaItem);
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => detailPage),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: lighterThemeColor,
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
                widget.mediaItem.imageUrl.replaceAll("t_thumb", "t_cover_big"),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.mediaItem.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(widget.mediaItem.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _toggleFavorite(); // Ensure the widget rebuilds with the updated favorite status
                });
              },
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
      appBar: AppBar(title: Text(mediaItem.title), backgroundColor: themeColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                mediaItem.imageUrl.replaceAll("t_thumb", "t_cover_big"),
                width: 264,
                height: 352,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback widget if the image fails to load
                  return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
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
        backgroundColor: themeColor,
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
                errorBuilder: (context, error, stackTrace) {
                  // Fallback widget if the image fails to load
                  return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
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

class MovieItem extends MediaItem {
  final String year;
  final String runtime;
  final String genre;
  final String metaScore;
  final String director;
  final List<String> stars;

  MovieItem({
    required super.title,
    required super.description,
    required super.imageUrl,
    this.year = "Unknown Year",
    this.runtime = "Unknown Runtime",
    this.genre = "Unknown Genre",
    this.metaScore = "N/A",
    this.director = "Unknown Director",
    this.stars = const [],
  });
}

class MovieDetailPage extends StatelessWidget {
  final MovieItem mediaItem;

  const MovieDetailPage({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mediaItem.title),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie poster
              Image.network(
                mediaItem.imageUrl,
                width: 264,
                height: 352,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback widget if the image fails to load
                  return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                mediaItem.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Overview/Description
              Text(
                mediaItem.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              // Additional Details
              Text("Year: ${mediaItem.year}"),
              Text("Runtime: ${mediaItem.runtime}"),
              Text("Genre: ${mediaItem.genre}"),
              Text("Director: ${mediaItem.director}"),
              Text("Meta Score: ${mediaItem.metaScore}"),
              const SizedBox(height: 10),

              // Stars
              Text(
                "Stars:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              for (var star in mediaItem.stars)
                Text(
                  star,
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameItem extends MediaItem {
  final int id;
  final String coverUrl;
  final String firstReleaseDate;
  final List<String> genres;
  final List<String> involvedCompanies;
  final List<String> keywords;
  final List<String> platforms;
  final List<String> screenshotUrls;
  final String summary;
  final String storyline;
  final List<String> themes;
  final double totalRating;
  final int totalRatingCount;

  GameItem({
    required this.id,
    required String title,
    required String description,
    required String imageUrl,
    this.coverUrl = "defaultUrl",
    this.firstReleaseDate = "2003-06-14",
    this.genres = const ["N/A"],
    this.involvedCompanies = const ["N/A"],
    this.keywords = const ["N/A"],
    this.platforms = const ["N/A"],
    this.screenshotUrls = const [],
    this.summary = "",
    this.storyline = "",
    this.themes = const ["N/A"],
    this.totalRating = -1.0,
    this.totalRatingCount = -1,
  }) : super(title: title, description: description, imageUrl: imageUrl);
}

class GameDetailPage extends StatelessWidget {
  final GameItem gameItem;

  const GameDetailPage({super.key, required this.gameItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                gameItem.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and rating
                    Text(
                      gameItem.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Rating: ${gameItem.totalRating}",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Platforms: ${gameItem.platforms.join(", ")}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // Tab selector
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            unselectedLabelColor: Colors.grey[400],
                            labelColor: themeColor,
                            tabs: [
                              Tab(text: "Description"),
                              Tab(text: "Details"),
                              Tab(text: "Screenshots"),
                            ],
                          ),
                          Container(
                            height: 300, // Adjust the height accordingly
                            child: TabBarView(
                              children: [
                                // Description Tab
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(gameItem.summary.isNotEmpty
                                      ? gameItem.summary
                                      : gameItem.storyline),
                                ),
                                // Details Tab
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Genres: ${gameItem.genres.join(", ")}"),
                                      Text(
                                          "Involved Companies: ${gameItem.involvedCompanies.join(", ")}"),
                                      Text(
                                          "Keywords: ${gameItem.keywords.join(", ")}"),
                                    ],
                                  ),
                                ),
                                // Screenshots Tab with Swipe
                                gameItem.screenshotUrls.isNotEmpty
                                    ? SizedBox(
                                        height: 200, // Adjust as needed
                                        child: PageView.builder(
                                          itemCount:
                                              gameItem.screenshotUrls.length,
                                          itemBuilder: (context, index) {
                                            return Image.network(
                                              gameItem.screenshotUrls[index]
                                                  .replaceAll("t_thumb",
                                                      "t_screenshot_huge"),
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      )
                                    : Center(
                                        child:
                                            Text("No screenshots available")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
