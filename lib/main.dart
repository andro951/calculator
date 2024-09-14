import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isaac\'s Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _result = '';
  bool _evaluated = false;

  bool isOperator(String value) {
    return RegExp(r'[/*+-]').hasMatch(value);
  }

  bool isNumeric(String value) {
    return RegExp(r'[0-9.]').hasMatch(value);
  }

  void _onPressed(String value) {
    setState(() {
      switch (value) {
        case 'C':
          _expression = '';
          _result = '';
          _evaluated = false;
          break;
        case '=':
          _evaluated = true;
          try {
            final expression = Expression.parse(_expression);
            const evaluator = ExpressionEvaluator();
            final result = evaluator.eval(expression, {});
            _result = ' = $result';
          } catch (e) {
            _result = ' Error';
          }
          break;
        case 'n':
          if (_expression.isEmpty) {
            _expression += '-';
            break;
          }

          final String lastChar = _expression[_expression.length - 1];
          if (lastChar == '-' || isNumeric(lastChar)) {
            int i = _expression.length - 1;
            while (i >= 0 && isNumeric(_expression[i])) {
              i--;
            }
            if (i < 0) {
              _expression = '-$_expression';
            }
            else if (i >= 0 && _expression[i] == '-' && (i == 0 || !isNumeric(_expression[i - 1]))) {
              _expression = _expression.substring(0, i) + _expression.substring(i + 1);
            } else {
              _expression = '${_expression.substring(0, i + 1)}-${_expression.substring(i + 1)}';
            }
          }
          else {
            _expression += '-';
          }

          break;
         default:
            if (_evaluated) {
              if (isNumeric(value)) {
                _expression = '';
              }
              
              _result = '';
              _evaluated = false;
            }

            _expression += value;
          break;
      }
    });
  }

  Color? buttonColor(String value) {
    const int colorStrength = 100;
    switch (value) {
      case 'C':
        return Colors.red[colorStrength];
      case '=':
        return Colors.green[colorStrength];
      case 'n':
        return Colors.purple[colorStrength];
    }

    if (isNumeric(value)) {
      return Colors.grey[colorStrength];
    }

    return Colors.blue[colorStrength];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                '$_expression$_result',
                style: const TextStyle(fontSize: 32.0),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 4,
              children: <String>[
                'C', '(', ')', '/',
                '7', '8', '9', '*',
                '4', '5', '6', '-',
                '1', '2', '3', '+',
                'n', '0', '.', '=',
              ].map((value) {
                return GridTile(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor(value),
                    ),
                    onPressed: () => _onPressed(value),
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}