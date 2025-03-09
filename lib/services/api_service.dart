import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000";
  static const String feedbackStats = "$baseUrl/api/feedback/stats";

  static Future<List<Map<String, dynamic>>> fetchFeedbackStats() async {
    try {
      final response = await http.get(Uri.parse(feedbackStats));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Failed to load feedback stats");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }
}
