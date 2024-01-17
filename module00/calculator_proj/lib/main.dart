import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mobileModule00/calculator_proj',
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
  String expression = '';
  String result = '';

  void buttonAction(String value) {
    setState(() {
      if (value == 'C') {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (value == 'AC') {
        clearAll();
      } else if (value == '=') {
        evaluateExpression();
      } else {
        expression = '$expression$value';
      }
    });
  }

  void clearAll() {
    result = '';
    expression = '';
  }

  void evaluateExpression() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression.replaceAll('x', '*'));
      ContextModel cm = ContextModel();

      result = '${exp.evaluate(EvaluationType.REAL, cm)}';
      if (result == 'Infinity') {
        result = 'Error';
      }
      debugPrint('Result = $result');
    } catch (e) {
      result = 'Syntax Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
          Display(expression: expression, result: result),
          Keyboard(buttonAction: buttonAction),
        ],
      ),
    );
  }
}

class Display extends StatelessWidget {
  final String expression;
  final String result;

  const Display({super.key, required this.expression, required this.result});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(expression),
            const SizedBox(height: 10),
            _buildTextField(result),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String text) {
    return TextField(
      controller: TextEditingController(text: text.isEmpty ? '0' : text),
      textAlign: TextAlign.right,
      style: const TextStyle(fontSize: 32),
      readOnly: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  final Function(String) buttonAction;

  const Keyboard({super.key, required this.buttonAction});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            children: _buildButtons(),
          );
        },
      ),
    );
  }

  List<Widget> _buildButtons() {
    return <String>[
      // @formatter:off
      '7', '8', '9', 'C', 'AC',
      '4', '5', '6', '+', '-',
      '1', '2', '3', 'x', '/',
      '0', '.', '00', '=', '',
      // @formatter:on
    ].map((key) {
      return GridTile(
        child: KeyboardKey(key, buttonAction),
      );
    }).toList();
  }
}

class KeyboardKey extends StatelessWidget {
  final String _keyValue;
  final Function(String) function;

  const KeyboardKey(this._keyValue, this.function, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: () => function(_keyValue),
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
