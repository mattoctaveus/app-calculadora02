import 'package:expressions/expressions.dart';
import 'dart:math'; // 
import 'package:flutter/material.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  // Parte 08: Definindo o botão de limpar
  final String _limpar = 'Limpar';

  // Parte 06: Variáveis para a expressão e o resultado
  String _expressao = '';
  String _resultado = '';

  // Parte 07: Função para pressionar um botão
  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado(); // Parte 09: Chama o cálculo quando pressionado "="
      } else {
        _expressao += valor; // Adiciona o valor à expressão
      }
    });
  }

  // Parte 11: Função para calcular o resultado
  void _calcularResultado() {
    try {
      // Verifica e executa funções como sin, cos, tan
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro: não foi possível calcular.'; 
    }
  }

  // Parte 10: Função para avaliar a expressão
  double _avaliarExpressao(String expressao) {
    // Substitui os símbolos de multiplicação e divisão
    expressao = expressao.replaceAll('×', '*');
    expressao = expressao.replaceAll('÷', '/');

    // Tratamento manual de funções matemáticas (seno, cosseno, tangente, etc.)
    if (expressao.contains('sin(')) {
      return _resolverFuncao('sin', expressao);
    } else if (expressao.contains('cos(')) {
      return _resolverFuncao('cos', expressao);
    } else if (expressao.contains('tan(')) {
      return _resolverFuncao('tan', expressao);
    } else if (expressao.contains('ln(')) {
      return _resolverFuncao('ln', expressao);
    } else if (expressao.contains('e^')) {
      return _resolverFuncao('e^', expressao);
    }

    // Avalia expressões simples (não contém funções científicas)
    ExpressionEvaluator avaliador = const ExpressionEvaluator();
    dynamic resultado = avaliador.eval(Expression.parse(expressao), {});
    return resultado.toDouble();
  }

  // Função para resolver expressões matemáticas específicas
  double _resolverFuncao(String funcao, String expressao) {
    String valorStr = expressao.replaceAll(RegExp(r'[a-zA-Z\(\)]'), ''); // Remove a função e os parênteses
    double valor = double.tryParse(valorStr) ?? 0.0;

    switch (funcao) {
      case 'sin':
        return sin(valor); // Seno
      case 'cos':
        return cos(valor); // Cosseno
      case 'tan':
        return tan(valor); // Tangente
      case 'ln':
        return log(valor); // Logaritmo natural
      case 'e^':
        return exp(valor); // Exponencial
      default:
        throw Exception('Função desconhecida'); // Caso a função não seja reconhecida
    }
  }

  // Função para criar o botão
  Widget _botao(String valor) {
    return TextButton(
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Parte 05: Exibição da expressão
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
        // Exibição do resultado
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
        // Parte 01: Definindo a grid de botões
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            // GridView permite colocar vários elementos em formato de tabela;
            childAspectRatio: 2,
            // Parte 03: Botões da calculadora
            children: [
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('×'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('0'),
              _botao('.'),
              _botao('='), // Botão de cálculo
              _botao('+'),
              // Funções científicas
              _botao('sin('),
              _botao('cos('),
              _botao('tan('),
              _botao('ln('),
              _botao('e^'),
            ],
          ),
        ),
        // Parte 04: Botão de limpar
        Expanded(
          child: _botao(_limpar), // Botão para limpar a expressão
        ),
      ],
    );
  }
}
