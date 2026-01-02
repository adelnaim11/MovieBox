import 'package:flutter/material.dart';
import 'package:mobiebox/screens/addmovie_page.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_carousel.dart';
import '../widgets/movie_section.dart';
import '../widgets/hamburger.dart';
import 'AdminManageMovies_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> _moviesFuture;
  String _filterCategory = "All";

  // --- State Variables for Authentication ---
  bool userIsAuthenticated = false;
  String? currentUsername;
  String? userRole = 'user'; // Change to 'admin' to test admin features

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    _moviesFuture = ApiService.fetchMovies();
  }

  void _setCategory(String category) {
    setState(() {
      _filterCategory = category;
    });
    // The HamburgerMenu handles its own Navigator.pop(context),
    // but this is a safe backup.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_filterCategory == "All" ? "Movies" : _filterCategory),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: HamburgerMenu(
        isLoggedIn: userIsAuthenticated,
        username: currentUsername,
        role: userRole,
        onHome: () => _setCategory("All"),
        onTop: () => _setCategory("Top"),
        onAction: () => _setCategory("Action"),
        onComedy: () => _setCategory("Comedy"),
        onDrama: () => _setCategory("Drama"),

        onManageMovies: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminManageMoviesPage(),
            ),
          ).then(
            (_) => setState(() => _loadMovies()),
          ); // Refresh after deleting
        },
        onLoginLogout: () {
          setState(() {
            userIsAuthenticated = false;
            currentUsername = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged out successfully")),
          );
        },
        onSettings: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Settings tapped")));
        },
        onAddMovie: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMoviePage()),
          ).then((_) => setState(() => _loadMovies())); // Refresh after adding
        },
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading movies",
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No movies found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final allMovies = snapshot.data!;

          // Helper function to filter movies by category
          List<Movie> getByCategory(String cat) =>
              allMovies.where((m) => m.category == cat).toList();

          // Determine carousel content
          final List<Movie> carouselMovies = _filterCategory == "All"
              ? getByCategory("Top").take(5).toList()
              : getByCategory(_filterCategory).take(5).toList();

          return RefreshIndicator(
            color: Colors.red,
            onRefresh: () async {
              setState(() {
                _loadMovies();
              });
            },
            child: ListView(
              children: [
                if (carouselMovies.isNotEmpty)
                  MovieCarousel(movies: carouselMovies),

                if (_filterCategory == "All" || _filterCategory == "Top")
                  MovieSection("🔥 Top Movies", getByCategory("Top")),

                if (_filterCategory == "All" || _filterCategory == "Action")
                  MovieSection("💥 Action", getByCategory("Action")),

                if (_filterCategory == "All" || _filterCategory == "Comedy")
                  MovieSection("😂 Comedy", getByCategory("Comedy")),

                if (_filterCategory == "All" || _filterCategory == "Drama")
                  MovieSection("🎭 Drama", getByCategory("Drama")),
              ],
            ),
          );
        },
      ),
    );
  }
}
