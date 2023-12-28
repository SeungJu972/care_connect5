import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _locationMessage = '';

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _locationMessage =
        '위도: ${position.latitude}, 경도: ${position.longitude}';
      });
    } catch (e) {
      print(e);
      setState(() {
        _locationMessage = '위치를 가져오는 중에 오류가 발생했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 위치'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('현재 위치 가져오기'),
            ),
            SizedBox(height: 20),
            Text(_locationMessage ?? '위치 정보가 없습니다.'),
          ],
        ),
      ),
    );
  }
}
