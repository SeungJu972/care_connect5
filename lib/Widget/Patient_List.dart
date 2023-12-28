import 'package:supabase/supabase.dart';
import 'package:flutter/material.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class PatientList extends StatefulWidget {
  final String username;
  final Function(String)? onPatientSelected;
  final void Function(String?)? onPatientIdChanged; // ID 변경을 전달하기 위한 함수
  const PatientList(
      {super.key,
      required this.username,
      this.onPatientSelected,
      this.onPatientIdChanged});

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  String? selectedPatientId; // DropdownButton에서 선택된 ID를 저장할 변수

  Future<List<Map<String, dynamic>>> getPatientData() async {
    final response = await supabase
        .from('relationship')
        .select('patient_name, patient_id')
        .eq('protector_id', widget.username)
        .execute();

    return (response.data as List).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getPatientData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No Patients');
        } else {
          return Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.all(2.0),
              child: DropdownButton<String>(
                isExpanded: true,
                borderRadius: BorderRadius.circular(20),
                value: selectedPatientId,
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPatientId = newValue;
                    widget.onPatientSelected?.call(newValue ?? ' ');
                    widget.onPatientIdChanged?.call(newValue);
                  });
                },
                items: snapshot.data!
                    .map<DropdownMenuItem<String>>((Map<String, dynamic> data) {
                  return DropdownMenuItem<String>(
                    value: data['patient_id'].toString(),
                    child: Text(data['patient_name'] as String),
                  );
                }).toList(),
              ));
        }
      },
    );
  }
}
