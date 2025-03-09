import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphSlider extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const GraphSlider({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double graphHeight = MediaQuery.of(context).size.height / 3;

    return SizedBox(
      height: graphHeight,
      child: PageView(
        children: [
          AverageRatingWidget(data: data),
          BarChartWidget(data: data), // New widget instead of line chart
        ],
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const BarChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: data.map((e) => e["count"]).reduce((a, b) => a > b ? a : b) + 2,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: data.map((entry) {
            return BarChartGroupData(
              x: entry["rating"].toInt(),
              barRods: [
                BarChartRodData(
                  toY: entry["count"].toDouble(),
                  color: Colors.blue.shade400,
                  width: 15,
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade900],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AverageRatingWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AverageRatingWidget({super.key, required this.data});

  double calculateAverageRating() {
    if (data.isEmpty) return 0.0;

    double totalRating = 0;
    double totalCount = 0;

    for (var entry in data) {
      totalRating += entry["rating"] * entry["count"];
      totalCount += entry["count"];
    }

    return totalCount > 0 ? totalRating / totalCount : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double avgRating = calculateAverageRating();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Average Rating",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            avgRating.toStringAsFixed(1), // Showing 1 decimal place
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
