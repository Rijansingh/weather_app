import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/weather_controller.dart';

class ForecastChart extends StatelessWidget {
  const ForecastChart({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherController weatherController = Get.find();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5-Day Forecast',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (weatherController.isLoading.value) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (weatherController.forecast.isEmpty) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text('No forecast data available')),
                );
              }
              return SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                            return Text(
                              // Remove const
                              value.toInt() < days.length
                                  ? days[value.toInt()]
                                  : '',
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            // Remove const
                            '${value.toInt()}°C',
                            style: const TextStyle(fontSize: 12),
                          ),
                          reservedSize: 30,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: weatherController.forecast
                            .asMap()
                            .entries
                            .map((e) => FlSpot(
                                e.key.toDouble(), e.value['temp'].toDouble()))
                            .toList(),
                        isCurved: true,
                        color: Theme.of(context).colorScheme.primary,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
