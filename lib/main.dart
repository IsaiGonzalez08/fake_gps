import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _latitude = "";
  String? _longitude = "";
  bool? _isMockLocation = false;

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
            print('Location is: $_isMockLocation');
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
    } else {
      print('No hay permisos');
    }
    _showMyDialog();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User location'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  _isMockLocation!
                      ? 'El usuario está usando una ubicación falsa \nMock Location: $_isMockLocation \nLatitude: $_latitude, Longitude: $_longitude'
                      : 'El usuario no está usando una ubicación falsa\n Mock Location: $_isMockLocation \nLatitude: $_latitude, Longitude: $_longitude',
                  style: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Salir'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trust Location Plugin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFF000000),
                ),
                width: 100,
                height: 50,
                child: InkWell(
                  onTap: () {
                    requestLocationPermission();
                  },
                  child: const Center(
                    child: Text(
                      'Ubicación',
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
