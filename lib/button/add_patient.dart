import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class RelationshipService {
  static Future<bool> doesPatientExist(String patientId) async {
    final response = await supabase
        .from('relationship')
        .select()
        .eq('patient_id', patientId)
        .execute();
    return (response.data as List).isNotEmpty;
  }

  static Future<void> addPatient({
    required String protectorId,
    required String patientId,
  }) async {
    final patientExists = await doesPatientExist(patientId);

    if (!patientExists) {
      final protectorResponse = await supabase
          .from('protector_users')
          .select('username, name')
          .eq('username', protectorId)
          .execute();

      final patientResponse = await supabase
          .from('patient_users')
          .select('username, name')
          .eq('username', patientId)
          .execute();
      final protectorData = protectorResponse.data as List<dynamic>;
      final patientData = patientResponse.data as List<dynamic>;
      final protectorUsername = protectorData.isEmpty
          ? ''
          : protectorData.first['username'] as String;
      final patientUsername =
          patientData.isEmpty ? '' : patientData.first['username'] as String;

      final protectorName =
          protectorData.isEmpty ? '' : protectorData.first['name'] as String;

      final patientName =
          patientData.isEmpty ? '' : patientData.first['name'] as String;

      await supabase.from('relationship').upsert([
        {
          'protector_id': protectorUsername,
          'protector_name': protectorName, // 추가: protector_name 필드
          'patient_id': patientUsername,
          'patient_name': patientName, // 추가: patient_name 필드
        },
      ]);
      print('피보호자가 추가되었습니다.');
    } else {
      print('이미 존재하는 피보호자입니다.');
    }
  }
}

class AddPatient extends StatelessWidget {
  //users table
  final String username;
  final String password;
  final patientController = TextEditingController();
  AddPatient({super.key, required this.username, required this.password});

  Future<void> addPatient() async {
    await RelationshipService.addPatient(
      protectorId: username,
      patientId: patientController.text,
    );
    print('피보호자가 추가되었습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 139, 202, 139),
        title: const Text('피보호자 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("로그인 성공! 사용자: $username"),
            const SizedBox(height: 20.0),
            TextField(
              controller: patientController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '피보호자 아이디',
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 139, 202, 139)),
              onPressed: addPatient,
              child: const Text('피보호자 추가'),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
