import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mobileModule00/ex02',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expression = '0';
  String result = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text(
                  //   expression,
                  //   textAlign: TextAlign.right,
                  //   style: const TextStyle(
                  //     fontSize: 40.0,
                  //   ),
                  // ),
                  // Text(
                  //   result,
                  //   textAlign: TextAlign.right,
                  //   style: const TextStyle(
                  //     fontSize: 40.0,
                  //   ),
                  // ),
                  TextField(
                    controller: TextEditingController(text: expression),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 32),
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none, // 밑줄을 없애는 부분
                      // contentPadding: EdgeInsets.zero, // 내용과 상하좌우 간격을 없애는 부분
                    ),
                  ),
                  TextField(
                    controller: TextEditingController(text: result),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 32),
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none, // 밑줄을 없애는 부분
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxButtonWidth = constraints.maxWidth / 4;
                double maxButtonHeight = constraints.maxHeight / 4;

                return GridView.count(
                  crossAxisCount: 5,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: maxButtonWidth / maxButtonHeight,
                  children: <String>[
                    '7',
                    '8',
                    '9',
                    'C',
                    'AC',
                    '4',
                    '5',
                    '6',
                    '+',
                    '-',
                    '1',
                    '2',
                    '3',
                    'x',
                    '/',
                    '0',
                    '.',
                    '00',
                    '=',
                    '',
                  ].map((key) {
                    return GridTile(
                      child: KeyboardKey(key),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  const KeyboardKey(this._keyValue, {Key? key}) : super(key: key);

  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // 여기서 모서리를 제거합니다.
        ),
      ),
      onPressed: () {},
      child: Text(
        _keyValue,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
