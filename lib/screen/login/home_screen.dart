import 'package:flutter/material.dart';
import 'package:care_connect/screen/login/join.dart';
import 'package:supabase/supabase.dart';
import 'package:care_connect/screen/home/main_screen.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthScreen();
  }
}

class AuthScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/appbarlogo.png', // 이미지 경로
                width: MediaQuery.of(context).size.width, // 화면 넓이에 맞게 이미지 확장
                fit: BoxFit.cover, // 이미지가 확장될 수 있도록 설정
              ),
              const SizedBox(height: 40.0),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: '아이디',
                  prefixIcon:Icon(Icons.person),
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: true, //입력값 암호화
                decoration: const InputDecoration(
                  hintText: '비밀번호',
                  prefixIcon:Icon(Icons.person),
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(

                onPressed: () async {
                  final response1 = await supabase
                      .from('patient_users') // patient_users 테이블로 변경
                      .select('username,password').execute();

                  final response2 = await supabase
                      .from('protector_users') // protector_users 테이블로 변경
                      .select('username,password').execute();

                  // 입력값과 비교
                  final enteredUsername = usernameController.text;
                  final enteredPassword = passwordController.text;

                  final users1 = (response1.data as List<dynamic>)
                      .cast<Map<String, dynamic>>(); // 테이블 정보 가져오기

                  final users2 = (response2.data as List<dynamic>)
                      .cast<Map<String, dynamic>>(); // 테이블 정보 가져오기

                  bool userFound = false;

                  for (final user in users1) {
                    // patient_users 테이블 필드 값과 같은게 있는지 확인하기
                    if (user['username'] == enteredUsername &&
                        user['password'] == enteredPassword) {
                      userFound = true;
                      break;
                    }
                  }

                  if (!userFound) {
                    for (final user in users2) {
                      // protector_users 테이블 필드 값과 같은게 있는지 확인하기
                      if (user['username'] == enteredUsername &&
                          user['password'] == enteredPassword) {
                        userFound = true;
                        break;
                      }
                    }
                  }

                  if (userFound) {
                    print('로그인 성공!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  MainScreen(
                          username: enteredUsername, password: enteredPassword,
                        ),
                      ),
                    );
                  } else {
                    print('로그인 실패. 아이디 또는 패스워드가 일치하지 않습니다.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF557C55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // 원하는 모서리 반지름 값
                  ),
                ),
                child: const Text('로그인'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1FCA01),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // 원하는 모서리 반지름 값
                  ),
                ),
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
