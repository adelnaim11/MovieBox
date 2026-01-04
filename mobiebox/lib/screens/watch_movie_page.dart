import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class WatchMoviePage extends StatefulWidget {
  final Movie movie;
  const WatchMoviePage({super.key, required this.movie});

  @override
  State<WatchMoviePage> createState() => _WatchMoviePageState();
}

class _WatchMoviePageState extends State<WatchMoviePage> {
  List<Movie> _similarMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSimilar();
  }

  Future<void> _loadSimilar() async {
    try {
      final movies = await ApiService.fetchSimilarMovies(
        widget.movie.category, 
        widget.movie.id
      );
      setState(() {
        _similarMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(widget.movie.title, 
          style: const TextStyle(fontSize: 18, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📺 PLAYER PLACEHOLDER
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(Icons.play_circle_fill, color: Colors.white, size: 80),
                ),
              ),
            ),
            
            // ℹ️ INFO
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.movie.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 15, height: 1.5)),
                ],
              ),
            ),
            
            const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("More Like This", 
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // 🍿 SIMILAR MOVIES LIST
            Container(
              height: 220,
              padding: const EdgeInsets.only(left: 16),
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _similarMovies.length,
                    itemBuilder: (context, index) {
                      final m = _similarMovies[index];
                      return GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => WatchMoviePage(movie: m)),
                        ),
                        child: Container(
                          width: 130,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(m.cover, fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(m.title, 
                                maxLines: 1, 
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 13)),
                              Text("⭐ ${m.rating}", 
                                style: const TextStyle(color: Colors.amber, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}