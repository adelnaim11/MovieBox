import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import 'watch_movie_page.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  final int? userId;
  final String? role;

  const MovieDetailsPage({
    super.key,
    required this.movie,
    required this.userId,
    required this.role,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  double _currentRating = 0;
  late Movie _movieDetails;

  @override
  void initState() {
    super.initState();
    _movieDetails = widget.movie;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Fetch user's personal rating and global movie details in parallel
    await Future.wait([_loadUserRating(), _refreshMovieData()]);
  }

  Future<void> _refreshMovieData() async {
    final updatedMovie = await ApiService.fetchMovieDetails(widget.movie.id);
    setState(() {
      _movieDetails = updatedMovie;
    });
  }

  Future<void> _loadUserRating() async {
    if (widget.userId != null) {
      final rating = await ApiService.getUserRating(
        widget.userId!,
        widget.movie.id,
      );
      setState(() => _currentRating = rating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Stack(
        children: [
          // 🔥 HERO IMAGES
          SizedBox(
            height: 350,
            child: PageView(
              children: widget.movie.images
                  .map(
                    (img) => Image.network(
                      img,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                  .toList(),
            ),
          ),

          // 🌈 GRADIENT OVERLAY
          Container(
            height: 350,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔙 APP BAR BACK BUTTON
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 📄 DRAGGABLE SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.85,
            builder: (_, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF121212),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: controller,
                  children: [
                    // 🎬 TITLE + RATING BADGE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "⭐ ${_movieDetails.rating} (${_movieDetails.votes})",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 📝 DESCRIPTION
                    Text(
                      widget.movie.description,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),

                    // 🌟 USER RATING
                    if (widget.userId != null && widget.role == 'user') ...[
                      const SizedBox(height: 20),
                      const Text(
                        "Rate this movie:",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < _currentRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () async {
                              setState(() {
                                _currentRating = (index + 1).toDouble();
                              });
                              try {
                                await ApiService.rateMovie(
                                  widget.userId!,
                                  widget.movie.id,
                                  _currentRating.toDouble(),
                                );
                                await _refreshMovieData();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Rating submitted!"),
                                  ),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to submit rating"),
                                  ),
                                );
                              }
                            },
                          );
                        }),
                      ),
                    ],

                    const SizedBox(height: 30),

                    // ▶ WATCH BUTTON
                    SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WatchMoviePage(movie: _movieDetails),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text(
                          "Watch Now",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
