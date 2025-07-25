// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:light/light.dart';
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
  double luxValue = 100;
  double sliderValue = 100;
  final double maxSliderValue = 2000;

  StreamSubscription<int>? _lightEvents;

  void startListening() {
    try {
      _lightEvents = Light().lightSensorStream.listen(
        (value) => setState(() {
          luxValue = value.toDouble();
          if (luxValue < maxSliderValue) {
            sliderValue = luxValue;
          }
        }),
      );
    } catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _lightEvents?.cancel();
  }

  @override
  void initState() {
    super.initState();
    startListening();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getRadialGauge(),
            Slider(
              min: 0,
              max: maxSliderValue,
              value: sliderValue,
              onChanged: (value) {
                setState(() {
                  luxValue = sliderValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRadialGauge() {
    return SfRadialGauge(
      title: GaugeTitle(
        text: '',
        textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 1001,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 300,
              color: Colors.red,
              startWidth: 10,
              endWidth: 10,
            ),
            GaugeRange(
              startValue: 300,
              endValue: 600,
              color: Colors.orange,
              startWidth: 10,
              endWidth: 10,
            ),
            GaugeRange(
              startValue: 600,
              endValue: 1000,
              color: Colors.green,
              startWidth: 10,
              endWidth: 10,
            ),
          ],
          pointers: <GaugePointer>[NeedlePointer(value: luxValue)],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                luxValue.toStringAsFixed(0),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
