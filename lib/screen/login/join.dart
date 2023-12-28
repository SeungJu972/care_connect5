import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String selectedRole = "보호자"; // 초기값 설정
  bool protector = true;
  bool isUsernameAvailable = true;
  String usernameAvailabilityMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 139, 202, 139),
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: '아이디'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 139, 202, 139)),
                    onPressed: () async {
                      await checkDuplicateUsername(usernameController.text);
                      // 중복검사 후에 회원가입 버튼의 활성화 여부 확인
                      checkSignUpButtonAvailability();
                    },
                    child: const Text('중복검사'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: '휴대폰번호'),
              ),
              const SizedBox(height: 24.0),
              const Text("역할 선택"),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (String? value) {
                  setState(() {
                    selectedRole = value!;
                    if (selectedRole == "피보호자") {
                      protector = false;
                    } else {
                      protector = true;
                    }
                  });
                },
                items: ["보호자", "피보호자"].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 139, 202, 139)),
                onPressed: isUsernameAvailable
                    ? null
                    : signUp, //usernameAvailabilityMessage을 참조
                child: const Text('회원가입'),
              ),
              const SizedBox(height: 16.0),
              Text(
                usernameAvailabilityMessage,
                style: TextStyle(
                  color: isUsernameAvailable ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkSignUpButtonAvailability() {
    setState(() {
      // 중복검사 결과에 따라 회원가입 버튼의 활성화 여부 설정
      isUsernameAvailable ? signUp : null;
    });
  }

  Future<void> checkDuplicateUsername(String username) async {
    String tableName = protector ? 'protector_users' : 'patient_users';
    var response = await supabase
        .from(tableName)
        .select('id')
        .eq('username', username)
        .limit(1)
        .execute();

    setState(() {
      isUsernameAvailable = response.data != null && response.data!.length > 0;
      if (isUsernameAvailable) {
        usernameAvailabilityMessage = '이미 사용 중인 아이디입니다.';
      } else {
        usernameAvailabilityMessage = '사용 가능한 아이디입니다.';
      }
    });
  }

  Future<void> signUp() async {
    String tableName = protector ? 'protector_users' : 'patient_users';
    var response = await supabase.from(tableName).upsert([
      {
        'name': nameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'phone_number': phoneNumberController.text,
      }
    ]);
    Navigator.of(context).pop();

  }
}
