import 'package:compass_widget/compass_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

main() {
  runApp(const CompassUI());
}

class CompassUI extends StatefulWidget {
  const CompassUI({Key? key}) : super(key: key);

  @override
  State<CompassUI> createState() => _CompassUIState();
}

class _CompassUIState extends State<CompassUI> {
  bool permissionGranted = false;


  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Location Permission Required'),
          ElevatedButton(
            child: const Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => permissionGranted = status == PermissionStatus.granted);
      }
    });
  }

  @override
  void initState() {
    _fetchPermissionStatus();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(15, 52, 62, 1.0),
          body: Center(
            child: permissionGranted
                ? Compass(
              background: SvgPicture.asset(
                'assets/compass.svg',
                fit: BoxFit.fitWidth,
                width: 400,
                color: Colors.greenAccent,
              ),
              foreground: SvgPicture.asset(
                'assets/needle.svg',
                fit: BoxFit.fitWidth,
                width: 400,
                color: Colors.greenAccent,
              ),
            )
                : _buildPermissionSheet(),
          )),
    );
  }
}
