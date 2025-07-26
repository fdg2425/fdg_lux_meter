import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LuxChart extends StatefulWidget {
  const LuxChart({super.key, required this.homePageState});

  final MyHomePageState homePageState;

  final Color chartColor = Colors.blue;

  @override
  State<LuxChart> createState() => _LuxChartState();
}

class _LuxChartState extends State<LuxChart> {
  final limitCount = 50;
  final luxPoints = <FlSpot>[];

  double xValue = 0;
  double step = 1;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      while (luxPoints.length > limitCount) {
        luxPoints.removeAt(0);
      }
      setState(() {
        luxPoints.add(FlSpot(xValue, widget.homePageState.luxValue));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return luxPoints.isNotEmpty
        ?
          // With a Column around the Padding the Expanded in main did not work -> chart was not shown ?!
          // Therefore I deleted the Column here
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: LineChart(
              duration: Duration.zero,
              LineChartData(
                minY: 0,
                maxY: 2000,
                minX: luxPoints.first.x,
                maxX: luxPoints.last.x,
                lineTouchData: const LineTouchData(enabled: false),
                clipData: const FlClipData.all(),
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: true),
                lineBarsData: [luxLine(luxPoints)],
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    //axisNameWidget: const Text("lux"),
                    //axisNameSize: 20,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      //interval: 250,
                      getTitlesWidget: (value, meta) {
                        return Text(" ${value.toStringAsFixed(0)} lx");
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles()),
                  topTitles: AxisTitles(sideTitles: SideTitles()),
                  bottomTitles: AxisTitles(sideTitles: SideTitles()),
                ),
              ),
            ),
          )
        : Container();
  }

  LineChartBarData luxLine(List<FlSpot> points) {
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
