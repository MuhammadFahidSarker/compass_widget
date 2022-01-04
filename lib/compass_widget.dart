library compass_widget;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class Compass extends StatelessWidget {
  final Widget background;
  final Widget foreground;
  final Widget _loading;
  final Widget _noSensorFound;
  final void Function()? onNoSensorFound;
  final void Function(double?)? onAccuracyChanged;

  const Compass(
      {Key? key,
        required this.background,
        required this.foreground,
        Widget? loading,
        this.onNoSensorFound,
        this.onAccuracyChanged,
        Widget? noSensorFound})
      : _loading = loading ??
      const Center(
        child: CircularProgressIndicator(),
      ),
        _noSensorFound = noSensorFound ??
            const Center(
              child: Text("No Sensors Available"),
            ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double _lastAngle = 0;
    double? _oldAccuracy;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading;
          }

          final data = snapshot.data;
          if (data != null) {
            double? direction = data.heading;
            double? accuracy = data.accuracy;
            if(accuracy != null){
              if (_oldAccuracy == null || _oldAccuracy != accuracy) {
                onAccuracyChanged?.call(accuracy);
                _oldAccuracy = accuracy;
              }
            }

            if (direction != null) {
              var heading = direction;

              if ((heading - _lastAngle).abs() > 0.5) {
                _lastAngle = heading;
              } else {
                heading = _lastAngle;
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  foreground,
                  Transform.rotate(
                      angle: -2 * pi * (heading / 360), child: background),
                ],
              );
            } else {
              onNoSensorFound?.call();
              return _noSensorFound;
            }
          } else {
            return _loading;
          }
        },
      ),
    );
  }
}
