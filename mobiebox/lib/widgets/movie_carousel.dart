import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/movie.dart';
import '../screens/movie_details_page.dart';



class MovieCarousel extends StatefulWidget {
  final List<Movie> movies;
  final int? userId;
  final String? role;

  const MovieCarousel({
    super.key,
    required this.movies,
    this.userId,
    this.role,
  });

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  late final PageController _controller;
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.85);

    // 🔁 AUTO SCROLL
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_controller.hasClients && widget.movies.length > 1) {
        _currentIndex = (_currentIndex + 1) % widget.movies.length;
        _controller.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox();

    final currentMovie = widget.movies[_currentIndex];

    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // 🌫️ BLURRED BACKGROUND
          Positioned.fill(
            child: Image.network(currentMovie.cover, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          // 🎞️ PAGE VIEW
          PageView.builder(
            controller: _controller,
            itemCount: widget.movies.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              HapticFeedback.lightImpact();
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final movie = widget.movies[index];

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double value = 1;

                  if (_controller.position.haveDimensions) {
                    value = _controller.page! - index;
                    value = (1 - value.abs() * 0.25).clamp(0.85, 1.0);
                  } else {
                    value = index == _currentIndex ? 1.0 : 0.8;
                  }

                  return Transform.scale(scale: value, child: child);
                },
                child: _MovieCard(
                  movie: movie,
                  userId: widget.userId,
                  role: widget.role,
                ),
              );
            },
          ),

          // 🔘 DOT INDICATORS
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.movies.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 12 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.redAccent
                        : Colors.white30,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  final int? userId; // Add this
  final String? role; // Add this

  const _MovieCard({required this.movie, this.userId, this.role});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MovieDetailsPage(movie: movie, userId: userId, role: role),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              // 🎬 IMAGE WITH PARALLAX
              Positioned.fill(
                child: Image.network(
                  movie.cover,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  filterQuality: FilterQuality.high,
                ),
              ),

              // 🌈 GRADIENT
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // ⭐ TITLE + RATING
              Positioned(
                left: 16,
                right: 16,
                bottom: 18,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "⭐ ${movie.rating}",
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
