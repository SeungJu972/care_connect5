import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'dart:math';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class DistanceAlarm extends StatefulWidget {
  final String username;
  final double? latitude;
  final double? longitude;
  final double? radius;

  const DistanceAlarm({
    required this.username,
    this.latitude,
    this.longitude,
    this.radius,
    Key? key,
  }) : super(key: key);

  @override
  _DistanceAlarmState createState() => _DistanceAlarmState();
}

class _DistanceAlarmState extends State<DistanceAlarm> {
  double distance = 0.0; // 거리 초기화

  @override
  void initState() {
    super.initState();
    checkUserLocation();
  }

  Future<void> checkUserLocation() async {
    final response = await supabase
        .from('action_location')
        .select('latitude, longitude')
        .eq('user_id', widget.username)
        .limit(1)
        .execute();

    if (response.data != null && response.data!.isNotEmpty) {
      final locationData = response.data!.first;
      double userLatitude = locationData['latitude'];
      double userLongitude = locationData['longitude'];
      distance = calculateDistance(
          widget.latitude!, widget.longitude!, userLatitude, userLongitude);

      if (distance > widget.radius!) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알람'),
              content: Text('사용자가 설정된 반경을 벗어났습니다!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('닫기'),
                ),
              ],
            );
          },
        );
      }
    }
    // 상태 업데이트 요청
    setState(() {});
  }


  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const int earthRadius = 6371;
    double latDiff = degreesToRadians(endLatitude - startLatitude);
    double lonDiff = degreesToRadians(endLongitude - startLongitude);
    double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(degreesToRadians(startLatitude)) *
            cos(degreesToRadians(endLatitude)) *
            sin(lonDiff / 2) * sin(lonDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    double distance = 1.07; // 거리 초기화

    return Scaffold(
      appBar: AppBar(
        title: Text('거리 알람'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('사용자 위치 체크 완료'),
              SizedBox(height: 20),
              Text(
                '사용자와의 거리: ${distance.toStringAsFixed(2)} km',
                // 거리를 텍스트로 표시
                style: TextStyle(fontSize: 18),
              ),
            ],
          )
      ),
    );
  }
}