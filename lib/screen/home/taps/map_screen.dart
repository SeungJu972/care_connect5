import 'package:flutter/material.dart';
import 'package:care_connect/button/add_patient.dart';
import 'package:care_connect/button/action_radius.dart';
import 'package:supabase/supabase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:care_connect/Widget/Patient_List.dart';
import 'package:care_connect/alram.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class MapScreen extends StatefulWidget {
  final String username;
  final String password;

  const MapScreen({
    required this.username,
    required this.password,
    Key? key,
  }) : super(key: key);

  @override
  _MapScreen createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  String selectedPatient = '';
  LatLng? patientLocation;
  double? radius, latitude, longitude;
  late GoogleMapController mapController;
  Set<Circle> circles = {};
  // 원을 관리하기 위한 세트

  Future<void> loadPatientLocation(String selectedPatient) async {
    final response = await supabase
        .from('users_location')
        .select('latitude, longitude, radius')
        .eq('user_id', selectedPatient)
        .limit(1) // 단일 레코드를 가져오도록 함
        .execute();

    final List<Map<String, dynamic>> locationDataList =
        (response.data as List).cast<Map<String, dynamic>>();

    if (locationDataList.isNotEmpty) {
      final Map<String, dynamic> locationData = locationDataList.first;

      latitude = locationData['latitude'] as double;
      longitude = locationData['longitude'] as double;
      radius = locationData['radius'] is int
          ? (locationData['radius'] as int).toDouble()
          : locationData['radius'] as double;

      // 위치 데이터를 사용하여 지도를 업데이트하거나 필요한 작업을 수행합니다.
      setState(() {
        patientLocation = LatLng(latitude!, longitude!);

        if (patientLocation != null && radius != null) {
          circles.clear();
          circles.add(
            Circle(
              circleId: const CircleId('1'),
              center: patientLocation!,
              radius: radius!,
              strokeWidth: 2,
              fillColor: Colors.blue.withOpacity(0.3),
              strokeColor: Colors.blue,
            ),
          );

          // Google 지도 컨트롤러로 이동
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(patientLocation!, 14),
          );
        }
      });
    }
  }

  void _onPatientSelected(String value) async {
    setState(() {
      selectedPatient = value;
    });

    await loadPatientLocation(selectedPatient);
  }

  @override
  void initState() {
    super.initState();
    loadPatientLocation(selectedPatient);
  }

  Set<Marker> _buildMarkers() {
    if (patientLocation != null) {
      return <Marker>{
        Marker(
          markerId: const MarkerId('user_location'),
          position: patientLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen), // 마커 아이콘 설정
          infoWindow: const InfoWindow(title: 'User Location'), // 정보창 설정
        ),
      };
    }
    return <Marker>{}.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            circles: circles,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: _buildMarkers(), // 사용자의 현재 위치 마커 추가
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
          Positioned(
            bottom: 36,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 139, 202, 139),
              onPressed: () {
                if (latitude != null && longitude != null && radius != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DistanceAlarm(
                        username: widget.username,
                        latitude: latitude!,
                        longitude: longitude!,
                        radius: radius!,
                      ),
                    ),
                  );
                } else {
                  // latitude, longitude, radius가 null인 경우에 대한 처리
                }
              },
              child: const Icon(Icons.access_alarms_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
