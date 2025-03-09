import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  _FeedbackFormScreenState createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0; // Use double for half-stars
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating < 0.5) { // Minimum rating should be 0.5
      _showMessage("Please select a rating!", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    final feedbackData = {
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "rating": _rating, // Now supports half values
      "feedback": _feedbackController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/api/feedback"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(feedbackData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage(responseData["message"] ?? "Feedback submitted!", Colors.green);
        _clearForm();
      } else {
        _showMessage("Failed to submit feedback. Try again!", Colors.red);
      }
    } catch (error) {
      _showMessage("Error: $error", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _feedbackController.clear();
    setState(() => _rating = 0);
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(fontSize: 16)), backgroundColor: color),
    );
  }

  Widget _buildRatingStars() {
    return RatingBar.builder(
      initialRating: _rating,
      minRating: 0.5, // Allows half-stars
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 40,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (rating) {
        setState(() => _rating = rating);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Give Feedback"),
      backgroundColor:  const Color.fromARGB(255, 170, 204, 255),),
      backgroundColor:  const Color.fromARGB(255, 216, 230, 252),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "We value your feedback!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration("Customer Name", Icons.person),
                      validator: (value) => value!.isEmpty ? "Enter your name" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration("Phone Number", Icons.phone),
                      validator: (value) => value!.length < 10 ? "Enter a valid phone number" : null,
                    ),
                    const SizedBox(height: 12),
                    const Text("Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    _buildRatingStars(),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _feedbackController,
                      maxLines: 3,
                      decoration: _inputDecoration("Your Feedback", Icons.feedback),
                      validator: (value) => value!.isEmpty ? "Enter your feedback" : null,
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: _submitForm,
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: const Text("Submit Feedback", style: TextStyle(fontSize: 16, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  const Color.fromARGB(255, 90, 149, 244),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      filled: true,
      fillColor:  const Color.fromARGB(255, 224, 237, 255),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
