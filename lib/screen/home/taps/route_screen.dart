import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:care_connect/Widget/Patient_List.dart';
import 'package:care_connect/button/add_patient.dart';
import 'package:care_connect/button/action_radius.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class RouteScreen extends StatefulWidget {
  final String username;
  final String password;

  const RouteScreen({
    required this.username,
    required this.password,
    Key? key,
  }) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  String selectedPatient = '';
  List<LatLng> userRoute = [];
  late GoogleMapController mapController;
  final Set<Polyline> _polylines = {}; // 폴리라인 상태 변수 선언

  void updatePolyline() {
    // 기존 Polyline을 제거하고 새 Polyline을 추가합니다.
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('user_location'), // 폴리라인의 ID
        points: userRoute, // 사용자의 경로
        color: Colors.redAccent,
        width: 10,
      ),
    );
  }

  Future<void> loadUserRoute(String selectedPatient) async {
    final response = await supabase
        .from('users_location')
        .select('latitude, longitude')
        .eq('user_id', selectedPatient)
        .order('timestamp', ascending: true)
        .execute();

    final List<Map<String, dynamic>> routeDataList =
        (response.data as List).cast<Map<String, dynamic>>();

    setState(() {
      userRoute.clear();
      for (final Map<String, dynamic> routeData in routeDataList) {
        if (routeData.containsKey('latitude') &&
            routeData.containsKey('longitude')) {
          double latitude = routeData['latitude'] as double;
          double longitude = routeData['longitude'] as double;
          userRoute.add(LatLng(latitude, longitude));
        }
      }
      print(userRoute);
    });

    updatePolyline(); // 사용자 경로 로드 후 폴리라인 업데이트
    if (userRoute.isNotEmpty) {
      // 사용자의 경로가 있다면 해당 위치를 지도 중심으로 설정합니다.
      mapController.animateCamera(
        CameraUpdate.newLatLng(userRoute.last),
      );
    }
  }

  void _onPatientSelected(String value) async {
    setState(() {
      selectedPatient = value;
    });

    await loadUserRoute(selectedPatient);
  }

  @override
  void initState() {
    super.initState();
    _onPatientSelected(selectedPatient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            polylines: _polylines, // 상태 변수로 변경
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 36),
              child: PatientList(
                username: widget.username,
                onPatientSelected: _onPatientSelected,
              ),
            ),
          ),
          Positioned(
            top: 36,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 139, 202, 139),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActionRadius(
                      username: widget.username,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add_location_alt_rounded),
            ),
          ),
          Positioned(
            top: 36,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 139, 202, 139),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPatient(
                      username: widget.username,
                      password: widget.password,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
