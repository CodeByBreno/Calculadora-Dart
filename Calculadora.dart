import 'dart:io';

const SIMBOLOGIA = {1: '+', 2: '-', 3: '*', 4: '/', 5: '//', 6: '%', 7: '^'};
const PRECISION = 2;

class Calculadora {
  List<List<String>> memoria = [];
  double? valor1, valor2, result;
  int? operation;

  Calculadora() {
    this.valor1 = 0;
    this.valor2 = 0;
    this.operation = 1;
  }

  void add_operation(double v1, int op, double v2) {
    this.valor1 = v1;
    this.valor2 = v2;
    this.operation = op;
  }

  void present() {
    double? v1, v2, r;
    String? op;

    op = SIMBOLOGIA[this.operation];
    v1 = this.valor1;
    v2 = this.valor2;
    r = this.result;
    print("$v1 $op $v2 = $r");
  }

  void clean() {
    this.valor1 = null;
    this.valor2 = null;
    this.result = null;
  }

  void ler_memoria() {
    String op, v1, v2, r;
    print("Operações realizadas: ");
    print(this.memoria.length);

    for (int i = 0; i < this.memoria.length; i++) {
      v1 = this.memoria[i][0];
      op = this.memoria[i][1];
      v2 = this.memoria[i][2];
      r = this.memoria[i][3];
      print("$v1 $op $v2" + " = " + r);
    }
  }

  double? save() {
    String op, v1, v2, r;

    op = SIMBOLOGIA[this.operation]!;
    v1 = this.valor1.toString();
    v2 = this.valor2.toString();
    r = this.result!.toStringAsFixed(PRECISION);

    if (this.result != null) {
      this.memoria.add([v1, op, v2, r]);
      return this.result;
    } else {
      return 0;
    }
  }

  double? calculate() {
    double? result;
    if (check_safety()) {
      switch (this.operation) {
        case 1:
          result = add();
          break;
        case 2:
          result = sub();
          break;
        case 3:
          result = mult();
          break;
        case 4:
          result = div();
          break;
        case 5:
          result = quociente();
          break;
        case 6:
          result = resto();
          break;
        case 7:
          result = pow();
          break;
        default:
          result = null;
          break;
      }
    } else {
      result = null;
    }
    return result;
  }

  bool check_safety() {
    if ((this.valor1 == null) ||
        (this.valor2 == null) ||
        (this.operation == null)) {
      return false;
    } else {
      return true;
    }
  }

  double? add() {
    this.result = this.valor1! + this.valor2!;
    return this.save();
  }

  double? sub() {
    this.result = this.valor1! - this.valor2!;
    return this.save();
  }

  double? mult() {
    this.result = this.valor1! * this.valor2!;
    return this.save();
  }

  double? div() {
    this.result = this.valor1! / this.valor2!;
    return this.save();
  }

  double? quociente() {
    this.result = (this.valor1!.toInt() ~/ this.valor2!.toInt()).toDouble();
    return this.save();
  }

  double? resto() {
    this.result = this.valor1! % this.valor2!;
    return this.save();
  }

  double? pow() {
    int i = 0;
    double aux = 1;

    for (i = 0; i < this.valor2!.toInt(); i++) aux *= this.valor1!;

    this.result = aux;
    return this.save();
  }
}

bool is_digit(String c) {
  if ((c.codeUnits[0] > 47) && (c.codeUnits[0] < 58)) {
    return true;
  } else {
    return false;
  }
}

bool is_operator(String c) {
  Iterable<String> simbols = SIMBOLOGIA.values;
  if (simbols.contains(c)) {
    return true;
  } else {
    return false;
  }
}

int value_simbol(String simbol) {
  Iterable<String> aux = SIMBOLOGIA.values;
  int c = 0;

  for (String item in aux) {
    c++;
    if (simbol == item) {
      return c;
    }
  }
  return -1;
}

String fix_dot(String entry) {
  String result = '';

  for (int i = 0; i < entry.length; i++) {
    if (entry[i] == ",") {
      result += ".";
    } else {
      result += entry[i];
    }
  }
  return result;
}

List<String> decompor(String? expression) {
  String valor1 = '', valor2 = '', op = '';
  int flag = 1, pass = 0;

  if (expression == null) {
    return [];
  }
  for (int i = 0; i < expression.length; i++) {
    if (flag == 1) {
      if (is_digit(expression[i]) ||
          (expression[i] == ',') ||
          (expression[i] == '.')) {
        valor1 = valor1 + expression[i];
      } else {
        pass = 1;
      }
    }

    if (flag == 2) {
      if (is_operator(expression[i])) {
        op = op + expression[i];
      } else {
        pass = 1;
      }
    }

    if (flag == 3) {
      if ((is_digit(expression[i])) ||
          (expression[i] == ',') ||
          (expression[i] == '.')) {
        valor2 = valor2 + expression[i];
      } else {
        pass = 1;
      }
    }

    if (pass == 1) {
      flag++;
      pass = 0;
    }
    if (flag > 3) {
      break;
    }
  }

  valor1 = fix_dot(valor1);
  valor2 = fix_dot(valor2);

  return [valor1, op, valor2];
}

bool eh_valida(List<String> content) {
  // ignore: unused_local_variable
  double? firstNumber, secondNumber;
  // ignore: unused_local_variable
  String? operator;

  if (content.length == 3) {
    try {
      firstNumber = double.parse(content[0]);
      secondNumber = double.parse(content[2]);
      operator = content[1];
      return true;
    } catch (e) {
      print("ERRO: ");
      if (e.runtimeType.toString() == "FormatException") {
        print("Operadores com formato inadequado");
      } else {
        print("Erro desconhecido");
      }
      return false;
    }
  } else {
    return false;
  }
}

Calculadora? menu_calculadora() {
  List<String> content = [];
  String? expression;
  Calculadora? calc = Calculadora();

  while (true) {
    print("\nInsira a operação que deseja fazer: ");
    print("Digite # se quiser sair");

    expression = stdin.readLineSync();
    if (expression == "#") break;

    content = decompor(expression);
    if (eh_valida(content)) {
      calc.add_operation(double.parse(content[0]), value_simbol(content[1]),
          double.parse(content[2]));

      calc.calculate();
      print("Resultado = " + calc.result!.toStringAsFixed(PRECISION));

      print("Pressione algo para continuar...");
      calc.ler_memoria();
      stdin.readLineSync();
    } else {
      print("Expressão Inválida");
    }
  }

  return calc;
}

void main() {
  bool flag = true;
  String? answer;
  Calculadora? calc;

  while (flag) {
    print("O que deseja fazer?");
    print("1 - Calcular");
    print("2 - Ver Histórico");
    print("other - Sair");
    answer = stdin.readLineSync();

    switch (answer) {
      case '1':
        calc = menu_calculadora();
        print("HISTÓRICO DEBUG");
        if (calc != null) calc.ler_memoria();
        break;
      case '2':
        if (calc != null) calc.ler_memoria();
        print("Pressione alguma coisa para continuar...");
        stdin.readLineSync();
        break;
      default:
        flag = false;
        break;
    }
  }
}
