import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:supabase/supabase.dart';
import 'package:care_connect/Widget/Patient_List.dart';

final supabase = SupabaseClient(
  'https://ygrxywqflblkpajkyzih.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlncnh5d3FmbGJsa3Bhamt5emloIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyMzM1NjYsImV4cCI6MjAxNDgwOTU2Nn0.fg4oIcH-RUV1NlpHX3I0oD4o_IngBpqFPxr_AFq2W3E',
);

class HealthScreen extends StatelessWidget {
  final String username;
  final String password;

  const HealthScreen({
    required this.username,
    required this.password,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Health Data",
      home: HealthDataScreen(username: username),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color.fromARGB(255, 139, 202, 139),
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 139, 202, 139))),
    );
  }
}

class HealthDataScreen extends StatefulWidget {
  final String username;
  const HealthDataScreen({Key? key, required this.username}) : super(key: key);

  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  String? heartRate;
  String? bp;
  String? sleeps;
  String? activeEnergy;
  String? bloodOxygen;

  String? bloodPreSys;
  String? bloodPreDia;

  int? sleepa;
  int? sleepb;
  int? heart;
  int? energy;
  int? oxygen;

  List<HealthDataPoint> healthData = [];

  HealthFactory health = HealthFactory();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    // define the types to get
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.BLOOD_OXYGEN,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      try {
        // fetch health data
        healthData = await health.getHealthDataFromTypes(yesterday, now, types);

        if (healthData.isNotEmpty) {
          for (HealthDataPoint h in healthData) {
            if (h.type == HealthDataType.HEART_RATE) {
              heartRate = "${h.value}";
              double x = double.parse(heartRate.toString());
              heart = x.toInt();
            } else if (h.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
              bloodPreSys = "${h.value}";
            } else if (h.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
              bloodPreDia = "${h.value}";
            } else if (h.type == HealthDataType.SLEEP_ASLEEP) {
              sleeps = "${h.value}";
              String sleep = sleeps.toString();
              double x = double.parse(sleep) / 60.0;
              double m = double.parse(sleep) % 60.0;
              sleepa = x.toInt();
              sleepb = m.toInt();
            } else if (h.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
              activeEnergy = "${h.value}";
              double x = double.parse(activeEnergy.toString());
              energy = x.toInt();
            } else if (h.type == HealthDataType.BLOOD_OXYGEN) {
              bloodOxygen = "${h.value}";
              double x = double.parse(bloodOxygen.toString()) / 0.01;
              oxygen = x.toInt();
            }
          }
          if (bloodPreSys != "null" && bloodPreDia != "null") {
            bp = "$bloodPreSys / $bloodPreDia mmHg";
          }

          setState(() {});
        }
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      healthData = HealthFactory.removeDuplicates(healthData);
    } else {
      print("Authorization not granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("건강 데이터"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 36),
                child: PatientList(
                  username: widget.username,
                  onPatientSelected: (selectedPatient) {
                    // 선택된 환자의 데이터를 가져오는 로직 추가 가능
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: healthCard(
                        title: "심박수",
                        image: "assets/health.png",
                        data: heartRate != "null" ? "$heart bpm" : "",
                        color: const Color(0xFF8d7ffa))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: healthCard(
                        title: "혈중 산소",
                        data: bloodOxygen != "null" ? "$oxygen %" : "",
                        image: "assets/bloodOxygen.png",
                        color: const Color.fromARGB(255, 153, 204, 255))),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: healthCard(
                        title: "수면 시간",
                        image: "assets/sleep.png",
                        data: "5시간 0분",
                        color: const Color(0xFF2086fd))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: healthCard(
                        title: "활동 에너지",
                        image: "assets/calories.png",
                        data:
                            activeEnergy != "null" ? "$activeEnergy kcal" : "",
                        color: const Color(0xFFf77e7e))),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget healthCard(
    {String title = "",
    String data = "",
    Color color = Colors.blue,
    required String image}) {
  return Container(
    height: 240,
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(20))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Image.asset(image, width: 70),
        Text(data),
      ],
    ),
  );
}
