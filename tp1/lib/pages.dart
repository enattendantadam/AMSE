import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tp1/utils.dart';
import '../sectionItems.dart';

ValueNotifier<List<MediaItem>> favoriteMediaNotifier = ValueNotifier([]);
const Color themeColor = Color.fromARGB(255, 23, 76, 141) as Color;
Color lighterThemeColor = themeColor.withValues(alpha: 0.5);

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
    FavoritePage(title: "favorites")
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/dice1.jpg'),
          fit: BoxFit.none,
          repeat: ImageRepeat.repeat,
        )),
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: themeColor,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: 'Movies',
              backgroundColor: themeColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              label: 'Games',
              backgroundColor: themeColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Comics',
              backgroundColor: themeColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
              backgroundColor: themeColor),
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
  List<MediaItem> mediaItems = [];

  @override
  void initState() {
    super.initState();
    _initializeMediaItems();
  }

  void _initializeMediaItems() {
    mediaItems = [
      MediaItem(
        title: "Example Item 1",
        description: "A thrilling adventure about...",
        imageUrl: "https://i.ebayimg.com/images/g/YcgAAOSwumRkjmNX/s-l400.jpg",
      ),
    ];
  }

  void _refresh() {
    setState(() {
      _initializeMediaItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        backgroundColor: themeColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => aboutPage(context)),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/dice1.jpg'),
          fit: BoxFit.none,
          repeat: ImageRepeat.repeat,
        )),
        child: Stack(
          children: [
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
                backgroundColor: themeColor.withValues(red: 0.3),
                onPressed: _refresh,
                child: Icon(
                  Icons.refresh,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FavoritePage extends StatefulWidget {
  final String title;

  const FavoritePage({super.key, required this.title});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<String> categories = ['All', 'Movies', 'Games', 'Comics'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        centerTitle: true,
        backgroundColor: themeColor,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => aboutPage(context)),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/dice1.jpg'),
            fit: BoxFit.none,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              TabBar(
                unselectedLabelColor: Colors.grey[400],
                labelColor: Colors.blue,
                tabs: [
                  Tab(text: "All"),
                  Tab(text: "Movies"),
                  Tab(text: "Games"),
                  Tab(
                    text: "Comics",
                  )
                ],
              ),
              Container(
                height: 300,
                child: TabBarView(
                  children: [
                    // "All" Tab - Display all favorites
                    _buildFavoriteTab("All"),

                    // Movie Tab
                    _buildFavoriteTab("Movies"),

                    // Game Tab
                    _buildFavoriteTab("Games"),

                    // Comic Tab
                    _buildFavoriteTab("Comics"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build each favorite tab
  Widget _buildFavoriteTab(String category) {
    return ValueListenableBuilder<List<MediaItem>>(
      valueListenable: favoriteMediaNotifier,
      builder: (context, favoriteItems, child) {
        List<MediaItem> filteredItems;

        if (category == "All") {
          filteredItems = favoriteItems;
        } else {
          switch (category) {
            case "Movies":
              filteredItems =
                  favoriteItems.where((item) => item is MovieItem).toList();
              break;
            case "Games":
              filteredItems =
                  favoriteItems.where((item) => item is GameItem).toList();
              break;
            case "Comics":
              filteredItems =
                  favoriteItems.where((item) => item is ComicItem).toList();
              break;
            default:
              filteredItems = favoriteItems;
              break;
          }
        }

        return filteredItems.isEmpty
            ? Center(child: Text("No favorites in this category."))
            : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return MediaItemWidget(mediaItem: filteredItems[index]);
                },
              );
      },
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
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    try {
      final igdbService = IgdbService();
      games = await igdbService.getGames();
      _updateMediaItems();
    } catch (e) {
      print('Error fetching games: $e');

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
    _fetchComics();
  }

  Future<void> _fetchComics() async {
    try {
      final comicVineService = ComicVineService();
      comics = await comicVineService.getComics();
      _updateMediaItems();
    } catch (e) {
      print('Error fetching comics: $e');
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
    await _fetchComics();
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
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      final imdbService = ImdbService();
      movies = await imdbService.getComics();
      _updateMediaItems();
    } catch (e) {
      print('Error fetching movies: $e');

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
    await _fetchMovies();
  }
}

Widget aboutPage(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("About"),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      centerTitle: true,
      backgroundColor: themeColor,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    "https://img.icons8.com/color/512/flutter.png"),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 20),

            Center(
              child: Text(
                "Flutter TP1 app",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),

            // App Description
            Text(
              "This app generates random movies, games or comics, through the use of 3 different APIs"
              "it is then possible to open a page with more details about each one."
              "The Api used were the IMDB api, the IGDB API and ComicVine API",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Divider(),

            Text(
              "Developed by",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text("Adam Menade", style: TextStyle(fontSize: 16)),
            Text("adam.menade@gmail.com",
                style: TextStyle(fontSize: 16, color: Colors.blue)),
            SizedBox(height: 20),

            Divider(),

            Text(
              "More Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.web, color: Colors.red[300]),
              title: Text(
                "Unrelated website also made by me (it was used as a webserver to hold the api keys)",
              ),
              onTap: () => launchUrl(Uri.parse("https://menade.me")),
              textColor: Colors.grey[400],
            ),
            ListTile(
                leading: Icon(
                  Icons.code,
                  color: Colors.red[300],
                ),
                title: Text("GitHub Repository"),
                onTap: () => launchUrl(
                    Uri.parse("https://github.com/enattendantadam/AMSE")),
                textColor: Colors.grey[400]),
          ],
        ),
      ),
    ),
  );
}
