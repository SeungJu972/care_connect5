import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key, Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      height: double.infinity,
      width: double.infinity,
      color: Colors.lightGreen[200],
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.lightGreen,
                            width: 4.0,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '0 걸음 걸었어요',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.lightGreen[200],
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '심박수 60bpm',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '혈중 산소 99%',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '수면시간 7시간',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '"오늘 0걸음 걸었어요"',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    '"평균 심박수는 60bpm으로 이상 없었어요"',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    '"혈중 산소는 99% 에요"',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    '"수면시간은 7시간 이에요"',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
