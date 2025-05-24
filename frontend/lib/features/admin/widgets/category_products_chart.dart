import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/admin/models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> earnings;
  const CategoryProductsChart({super.key, required this.earnings});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: _getMaxY(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < earnings.length) {
                  return Text(
                    earnings[index].label,
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        barGroups: List.generate(earnings.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: earnings[index].earnings.toDouble(),
                color: Colors.blue,
                width: 16,
              ),
            ],
          );
        }),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }

  double _getMaxY() {
    return earnings
            .map((e) => e.earnings)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        10;
  }
}
