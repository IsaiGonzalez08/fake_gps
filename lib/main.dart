import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _latitude;
  String? _longitude;
  bool? _isMockLocation;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getLocation() async {
    try {
      TrustLocation.onChange.listen((values) => setState(() {
            _latitude = values.latitude;
            _longitude = values.longitude;
            _isMockLocation = values.isMockLocation;
          }));
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  void requestLocationPermission() async {
    final permission = await Permission.location.request();
    TrustLocation.start(5);
    if (permission.isGranted) {
      getLocation();
      print('permissions: $permission');
    } else {
      print('No hay permisos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trust Location Plugin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            children: <Widget>[
              Container(
                color: const Color(0xFF000000),
                width: 100,
                height: 50,
                child: InkWell(
                    onTap: () {
                      requestLocationPermission();
                    },
                    child: const Center(
                      child: Text(
                        'Ubicación',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    )),
              ),
              Text('Mock Location: $_isMockLocation'),
              Text('Latitude: $_latitude, Longitude: $_longitude'),
            ],
          )),
        ),
      ),
    );
  }
}
