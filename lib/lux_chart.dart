import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LuxChart extends StatefulWidget {
  const LuxChart({super.key, required this.homePageState});

  final MyHomePageState homePageState;

  final Color sinColor = Colors.blue;
  final Color cosColor = Colors.pink;

  @override
  State<LuxChart> createState() => _LuxChartState();
}

class _LuxChartState extends State<LuxChart> {
  final limitCount = 50;
  final sinPoints = <FlSpot>[];

  double xValue = 0;
  double step = 1;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(xValue, widget.homePageState.luxValue));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return sinPoints.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 1500,
                      minX: sinPoints.first.x,
                      maxX: sinPoints.last.x,
                      lineTouchData: const LineTouchData(enabled: false),
                      clipData: const FlClipData.all(),
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [sinLine(sinPoints)],
                      titlesData: const FlTitlesData(show: true),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(show: true),
      color: Colors.blue,
      // gradient: LinearGradient(
      //   colors: [widget.sinColor.withValues(alpha: 0), widget.sinColor],
      //   stops: const [0.1, 1.0],
      // ),
      barWidth: 2,
      isCurved: true,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
