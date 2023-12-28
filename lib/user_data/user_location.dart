import 'package:supabase/supabase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> saveLocationData(double latitude, double longitude) async {
  // Supabase URL과 Key 설정
  final supabaseUrl = 'https://ygrxywqflblkpajkyzih.supabase.co';
  final supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E';

  final url = Uri.parse('$supabaseUrl/rest/v1/users_location'); // 데이터를 저장할 테이블 URL
  final headers = {
    'Content-Type': 'application/json',
    'apikey': supabaseKey,
  };

  final timestamp = DateTime.now().toIso8601String(); // 현재 시간을 timestamp 필드에 저장

  // 데이터를 JSON 형태로 변환하여 HTTP POST 요청으로 Supabase에 저장
  final response = await http.post(
    url,
    headers: headers,
    body: json.encode({
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    }),
  );

  if (response.statusCode == 201) {
    print('Location data saved successfully');
  } else {
    print('Failed to save location data. Error: ${response.statusCode}');
    print(response.body);
  }
}
