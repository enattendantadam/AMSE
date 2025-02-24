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
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MoviePage(),
    VideoGamePage(),
    ComicsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Comics'),
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

  void _refresh() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: mediaItems.length,
          itemBuilder: (context, index) {
            return MediaItemWidget(mediaItem: mediaItems[index]);
          },
        ),
        Positioned(
          right: 10,
          bottom: 25,
          child: FloatingActionButton(
            onPressed: _refresh,
            child: Icon(Icons.refresh),
          ),
        )
      ]),
    );
  }
}

class VideoGamePage extends SectionPage {
  VideoGamePage({super.key}) : super(title: "Games");

  @override
  _VideoGamePageState createState() => _VideoGamePageState();
}

class _VideoGamePageState extends _SectionPageState {
  List<Game> games = [];

  @override
  void initState() {
    super.initState();
    _fetchGames(); // Call fetch games in initState
  }

  Future<void> _fetchGames() async {
    try {
      final igdbService = IgdbService();
      games = await igdbService.getGames();
      _updateMediaItems(); // Update mediaItems after fetching
    } catch (e) {
      print('Error fetching games: $e');
      //ScaffoldMessenger.of(context).showSnackBar(
      //  SnackBar(content: Text('Error loading games: $e')),
      //);
      games = [
        Game(
          id: 0,
          name: "Example VG 1",
          summary: "A thrilling adventure about...",
          coverUrl:
              "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
        ),
      ];
    } finally {
      _updateMediaItems();
    }
  }

  void _updateMediaItems() {
    mediaItems = games.map((game) {
      return GameItem(
        title: game.name,
        description: game.summary.isNotEmpty ? game.summary : game.storyline,
        imageUrl: game.coverUrl.replaceAll("t_thumb", "t_cover_big"),
        id: game.id,
        coverUrl: game.coverUrl,
        firstReleaseDate: game.firstReleaseDate,
        genres: game.genres,
        involvedCompanies: game.involvedCompanies,
        keywords: game.keywords,
        platforms: game.platforms,
        screenshotUrls: game.screenshotUrls,
        summary: game.summary,
        storyline: game.storyline,
        themes: game.themes,
        totalRating: game.totalRating,
        totalRatingCount: game.totalRatingCount,
      );
    }).toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Future<void> _refresh() async {
    // Override the refreshData method
    await _fetchGames(); // Fetch new games
  }
}

class ComicsPage extends SectionPage {
  ComicsPage({super.key}) : super(title: "Comics");

  @override
  _ComicsPageState createState() => _ComicsPageState();
}

class _ComicsPageState extends _SectionPageState {
  List<Comic> comics = [];

  @override
  void initState() {
    super.initState();
    _fetchComics(); // Call fetch games in initState
  }

  Future<void> _fetchComics() async {
    try {
      final comicVineService = ComicVineService();
      comics = await comicVineService.getComics();
      _updateMediaItems(); // Update mediaItems after fetching
    } catch (e) {
      print('Error fetching comics: $e');
      //ScaffoldMessenger.of(context).showSnackBar(
      //  SnackBar(content: Text('Error loading games: $e')),
      //);
      comics = [
        Comic(
          id: 0,
          name: "Example VG 1",
          description: "A thrilling adventure about...",
          image:
              "https://comicvine.gamespot.com/a/uploads/scale_medium/6/66303/3321885-screen%20shot%202013-09-19%20at%2010.24.07%20am.png",
        ),
      ];
    } finally {
      _updateMediaItems();
    }
  }

  void _updateMediaItems() {
    mediaItems = comics.map((comic) {
      return ComicItem(
        title: comic.name,
        releaseDate: comic.coverDate,
        htmlDescription: comic.htmlraw,
        description: comic.deck.isNotEmpty
            ? "${comic.deck}\n${comic.description}"
            : comic.description,
        imageUrl: comic.image.isNotEmpty
            ? comic.image.replaceAll("square_avatar", "scale_medium")
            : "https://gssc.esa.int/navipedia/images/a/a9/Example.jpg",
      );
    }).toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Future<void> _refresh() async {
    // Override the refreshData method
    await _fetchComics(); // Fetch new games
  }
}

class MoviePage extends SectionPage {
  MoviePage({super.key}) : super(title: "Movies");

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends _SectionPageState {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies(); // Call fetch games in initState
  }

  Future<void> _fetchMovies() async {
    try {
      final imdbService = ImdbService();
      movies = await imdbService.getComics();
      _updateMediaItems(); // Update mediaItems after fetching
    } catch (e) {
      print('Error fetching movies: $e');
      //ScaffoldMessenger.of(context).showSnackBar(
      //  SnackBar(content: Text('Error loading games: $e')),
      //);
      movies = [
        Movie(
          image:
              "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTfE_qrYMBZ_JB8om-34WGaZARhpX26yWRttqIDvn4_7l--UzX8mxKcPrc59IcvTpEA_G8gPA",
          title: 'Batman the dark knight',
          year: '2008',
          runtime: '152 min',
          genre: 'best',
          metaScore: '100',
          overview:
              'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
          director: 'Christopher Nolan',
          stars: [
            "Christian Bale",
            "Heath Ledger",
            "Aaron Eckhart",
            "Michael Caine"
          ],
        )
      ];
    } finally {
      _updateMediaItems();
    }
  }

  void _updateMediaItems() {
    mediaItems = movies.map((movie) {
      return MovieItem(
          title: movie.title,
          description: movie.overview,
          imageUrl: movie.image,
          year: movie.year,
          runtime: movie.runtime,
          genre: movie.genre,
          metaScore: movie.metaScore,
          stars: movie.stars,
          director: movie.director);
    }).toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Future<void> _refresh() async {
    // Override the refreshData method
    await _fetchMovies(); // Fetch new games
  }
}
