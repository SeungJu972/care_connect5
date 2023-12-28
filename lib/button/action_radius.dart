import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:care_connect/Widget/Patient_List.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class ActionRadius extends StatefulWidget {
  final String username;

  const ActionRadius({super.key, required this.username});

  @override
  State<ActionRadius> createState() => _ActionRadiusState();
}

class _ActionRadiusState extends State<ActionRadius> {
  final TextEditingController radiusController = TextEditingController();
  String selectedPatient = '';

  Future<void> addUserLocation() async {
    final double radius = double.tryParse(radiusController.text) ?? 0;

    // 테이블에 행동반경 저장
    final response = await supabase
        .from('users_location')
        .update({'radius': radius})
        .eq('user_id', selectedPatient)
        .execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 139, 202, 139),
        title: const Text('행동반경 범위 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: PatientList(
                  username: widget.username,
                  onPatientSelected: (value) {
                    setState(() {
                      selectedPatient = value; // 선택된 값을 저장
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: radiusController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '행동 반경',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 139, 202, 139)),
              onPressed: addUserLocation,
              child: const Text('알람 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
