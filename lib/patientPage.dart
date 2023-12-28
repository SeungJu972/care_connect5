import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase/supabase.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class PatientPage extends StatefulWidget {
  final String username;
  final String password;

  const PatientPage({
    required this.username,
    required this.password,
    Key? key,
  }) : super(key: key);

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndStartTracking();
  }

  Future<void> _checkPermissionsAndStartTracking() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
      if (status != LocationPermission.whileInUse &&
          status != LocationPermission.always) {
        // 위치 권한을 거부한 경우 처리
        print('사용자가 위치 권한을 거부했습니다.');
        return;
      }
    }

    if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      _startLocationTracking();
    }
  }

  void _startLocationTracking() {
    Geolocator.getPositionStream().listen((Position position) async {
      setState(() {
        _currentPosition = position;
      });

      await _saveLocationToSupabase(
        widget.username,
        position.latitude,
        position.longitude,
      );
    });
  }

  Future<void> _saveLocationToSupabase(
      String username,
      double latitude,
      double longitude,
      ) async {

      final response = await supabase.from('users_location')
          .upsert([
        {
          'user_id': username,
          'latitude': latitude,
          'longitude': longitude,
        },
      ],
          onConflict: 'user_id', ).single();
      if (response.error != null) {
        print('Error inserting location: ${response.error!.message}');
      }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                'Current Location: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}',
              ),
          ],
        ),
      ),
    );
  }
}
