// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'lux_chart.dart';
import 'settings/settings_page.dart';
import 'settings/settings_provider.dart';

// Declare a global late variable for SharedPreferences
// This will be initialized once in the main function.
late SharedPreferences globalPrefs;

void main() async {
  // Ensure that the Flutter binding is initialized. This is required before
  // calling any plugin-specific code, including SharedPreferences.getInstance().
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the global SharedPreferences instance here.
  // This ensures it's available throughout the app after startup.
  globalPrefs = await SharedPreferences.getInstance();

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
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  double sliderValue = 400;
  final double maxSliderValue = 2000;
  double _luxValue = 400;
  late SettingsProvider settingsProvider;

  double get luxValue => _luxValue;

  StreamSubscription<int>? _lightEvents;

  void startListening() {
    try {
      _lightEvents = Light().lightSensorStream.listen(
        (value) => setState(() {
          _luxValue = value.toDouble();
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

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    settingsProvider = SettingsProvider(callbackOnSettingsChange: refresh);
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
        //title: Text(widget.title),
        title: Text("FDG Lux Meter"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(settingsProvider: settingsProvider),
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            _getRadialGauge(),
            Slider(
              min: 0,
              max: maxSliderValue,
              value: sliderValue,
              onChanged: (value) {
                setState(() {
                  _luxValue = sliderValue = value;
                });
              },
            ),
            Expanded(child: LuxChart(homePageState: this)),
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
                "${luxValue.toStringAsFixed(0)} lx",
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
