import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Graphique permetant de comparer les [notes] avec les [moyennes] de classe.
class Chart extends StatelessWidget {
  final List<double> notes;
  final List<double> moyennes;
  final bool showMoyenne;
  const Chart(this.notes, this.moyennes, {Key? key, this.showMoyenne = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double index = 0;
    final List<FlSpot> spots = notes.map((e) => FlSpot(index++, e)).toList();
    index = 0;
    final List<FlSpot> spots2 =
        moyennes.map((e) => FlSpot(index++, e)).toList();

    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];
    final List<Color> gradientColors2 = [
      const Color(0xffff0000),
    ];
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: true, interval: 1)),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        minY: 0,
        maxY: 6.5,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.1,
            colors: gradientColors,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,

              /// It's creating a gradient with the colors in `gradientColors` with an opacity of 0.3.
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
          if (showMoyenne)
            LineChartBarData(
              spots: spots2,
              isCurved: true,
              colors: gradientColors2,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
            ),
        ],
      ), // Optional
    );
  }
}
