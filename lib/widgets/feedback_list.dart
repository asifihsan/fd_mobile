import 'package:flutter/material.dart';

class FeedbackList extends StatelessWidget {
  final List<Map<String, dynamic>> feedbackData;

  const FeedbackList({super.key, required this.feedbackData});

  Widget buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor(); // Get the whole number part
    bool hasHalfStar = (rating - fullStars) >= 0.5; // Check if there's a half-star

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        // Full star
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 22));
      } else if (i == fullStars && hasHalfStar) {
        // Half star
        stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 22));
      } else {
        // Empty star
        stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 22));
      }
    }

    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: feedbackData.isEmpty
          ? const Center(
              child: Text("No feedback available", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: feedbackData.length,
              itemBuilder: (context, index) {
                final item = feedbackData[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: const Icon(Icons.account_circle, size: 40, color: Colors.blueGrey),
                    title: Text(
                      item['customer_name'] ?? "Unknown",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildStarRating((item['rating'] ?? 0).toDouble()),
                        const SizedBox(height: 4),
                        Text(
                          item['feedback_text'] ?? "No feedback provided",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['timestamp'] ?? "",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
