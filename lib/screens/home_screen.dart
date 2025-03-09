import 'dart:async';
import 'dart:convert';
import 'package:fd_mobile/widgets/feedback_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../widgets/graph_slider.dart';
import 'feedback_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> feedbackData = [];
  late Timer _timer;
  late Timer _timer2;
  List<Map<String, dynamic>> feedbackData2 = [];
  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) => fetchData());
    fetchData2();
    _timer2 = Timer.periodic(const Duration(seconds: 10), (timer) => fetchData2());
  }
 Future<void> fetchData2() async {
    List<Map<String, dynamic>> newData = await ApiService.fetchFeedbackStats();
    if (mounted) {
      setState(() {
        feedbackData2 = newData;
      });
    }
  }
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse("http://localhost:3000/api/feedback"));
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> newData = List<Map<String, dynamic>>.from(json.decode(response.body));
        if (mounted) {
          setState(() {
            feedbackData = newData;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching feedback: $e");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Welcome to Feedback Hub",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: feedbackData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GraphSlider(data: feedbackData2),
          ),
          
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackFormScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
            child: const Text("Give Feedback", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          
          const SizedBox(height: 20),
          Expanded(
            child: FeedbackList(feedbackData: feedbackData),
          ),
        ],
      ),
    );
  }
}
