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
  final limitCount = 60;
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
                maxY: widget.homePageState.settingsProvider.maxOnYAxis,
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
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles:
                          widget.homePageState.settingsProvider.showXAxis,
                      maxIncluded: false,
                      minIncluded: luxPoints.length < limitCount,
                      interval: getInterval(),
                      getTitlesWidget: (value, meta) {
                        return Text(" ${(value / 2).toStringAsFixed(0)} s");
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  LineChartBarData luxLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: widget.homePageState.settingsProvider.showDots,
        getDotPainter:
            (
              FlSpot spot,
              double xPercentage,
              LineChartBarData bar,
              int index, {
              double? barWidth,
            }) {
              return FlDotCirclePainter(
                radius: 3,
                color: Colors.blue,
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
      ),
      color: Colors.blue,
      // The following gradient would show small values in red and big ones in green.
      // Because I plan that the user can select the max value of the y axis, it would be
      // difficult to correlate these colors to the corresponding colors in the gauge.
      // Therefore we stay with blue.
      // gradient: LinearGradient(
      //   begin: Alignment.bottomCenter,
      //   end: Alignment.topCenter,
      //   colors: [Colors.red, Colors.orange, Colors.green],
      //   stops: const [0.1, 0.3, 0.6],
      // ),
      barWidth: 2,
      belowBarData: BarAreaData(
        show: widget.homePageState.settingsProvider.showBelowBarData,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.withValues(alpha: 0.7),
            Colors.blue.withValues(alpha: 0.1),
          ],
          stops: const [0, 0.9],
        ),
      ),
      isCurved: true,
    );
  }

  double getInterval() {
    double result = 10; // mark every 5s
    var length = luxPoints.length;
    if (length < 20) {
      result = 2; // every second
    } else if (length < 40) {
      result = 4; // every two seconds
    }
    return result;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
