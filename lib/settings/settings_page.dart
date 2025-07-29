import 'package:flutter/material.dart';

import 'settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.settingsProvider});

  final SettingsProvider settingsProvider;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final textStyleNormal = const TextStyle(fontSize: 18);
  final textStyleUnderlined = const TextStyle(
    fontSize: 18,
    decoration: TextDecoration.underline,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 20, 10, 10),
              child: Text(
                "Maximum value on y axis: ${widget.settingsProvider.maxOnYAxis.toStringAsFixed(0)}",
                style: textStyleNormal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Slider(
                min: 500,
                max: 5000,
                divisions: 9,
                label: widget.settingsProvider.maxOnYAxis.toStringAsFixed(0),
                value: widget.settingsProvider.maxOnYAxis,
                onChanged: (value) {
                  setState(() {
                    widget.settingsProvider.maxOnYAxis = value;
                  });
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 10),
              child: SwitchListTile(
                title: Text("Show time in the x axis?", style: textStyleNormal),
                value: widget.settingsProvider.showXAxis,
                onChanged: (value) {
                  setState(() {
                    widget.settingsProvider.showXAxis = value;
                  });
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 10),
              child: SwitchListTile(
                title: Text("Show dots in the chart?", style: textStyleNormal),
                value: widget.settingsProvider.showDots,
                onChanged: (value) {
                  setState(() {
                    widget.settingsProvider.showDots = value;
                  });
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 10),
              child: SwitchListTile(
                title: Text(
                  "Fill area below the chart?",
                  style: textStyleNormal,
                ),
                value: widget.settingsProvider.showBelowBarData,
                onChanged: (value) {
                  setState(() {
                    widget.settingsProvider.showBelowBarData = value;
                  });
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 10, 25, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Version info", style: textStyleUnderlined),
                  Text(
                    "This is version 0.5 from 05-Jul-2025,\n"
                    "developed during a Flutter training at FDG.",
                    style: textStyleNormal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
