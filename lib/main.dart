import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_getRadialGauge()],
        ),
      ),
    );
  }

  Widget _getRadialGauge() {
    return SfRadialGauge(
      title: GaugeTitle(
        text: 'Speedometer',
        textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 150,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 50,
              color: Colors.green,
              startWidth: 10,
              endWidth: 10,
            ),
            GaugeRange(
              startValue: 50,
              endValue: 100,
              color: Colors.orange,
              startWidth: 10,
              endWidth: 10,
            ),
            GaugeRange(
              startValue: 100,
              endValue: 150,
              color: Colors.red,
              startWidth: 10,
              endWidth: 10,
            ),
          ],
          pointers: <GaugePointer>[NeedlePointer(value: 90)],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Container(
                child: const Text(
                  '90.0',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        ),
      ],
    );
  }
}
