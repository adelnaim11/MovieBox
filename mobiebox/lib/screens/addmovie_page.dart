import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMoviePage extends StatefulWidget {
  const AddMoviePage({super.key});

  @override
  State<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _ratingController = TextEditingController();
  final _categoryController = TextEditingController();
  final _coverController = TextEditingController();

  // List to hold controllers for multiple image URLs
  List<TextEditingController> _imageControllers = [TextEditingController()];
  bool _isSaving = false;

  void _addImageField() =>
      setState(() => _imageControllers.add(TextEditingController()));

  Future<void> _saveMovie() async {
    setState(() => _isSaving = true);

    final List<String> extraImages = _imageControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    try {
      final url = Uri.parse("http://10.0.2.2/movies_backend/api/add_movie.php");
      final response = await http.post(
        url,
        body: jsonEncode({
          "title": _titleController.text,
          "description": _descController.text,
          "rating": _ratingController.text,
          "category": _categoryController.text,
          "cover": _coverController.text,
          "images": extraImages, // Send list of extra images
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error saving movie")));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add New Movie"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInput(_titleController, "Title", Icons.movie),
            _buildInput(
              _descController,
              "Description",
              Icons.description,
              maxLines: 3,
            ),
            _buildInput(_ratingController, "Rating (e.g. 8.5)", Icons.star),
            _buildInput(_categoryController, "Category", Icons.category),
            _buildInput(_coverController, "Main Cover URL", Icons.image),
            const Divider(color: Colors.white24, height: 40),
            const Text(
              "Extra Gallery Images",
              style: TextStyle(color: Colors.white70),
            ),
            ..._imageControllers.map(
              (controller) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child: _buildInput(
                  controller,
                  "Image URL",
                  Icons.add_photo_alternate,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _addImageField,
              icon: const Icon(Icons.add, color: Colors.redAccent),
              label: const Text(
                "Add Another Image URL",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 30),
            _isSaving
                ? const CircularProgressIndicator(color: Colors.redAccent)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _saveMovie,
                    child: const Text(
                      "SAVE MOVIE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.redAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
