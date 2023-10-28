import 'dart:io';

const simbologia = {1: '+', 2: '-', 3: '*', 4: '/', 5: '//', 6: '%', 7: '^'};

bool is_digit(String c) {
  if ((c.codeUnits[0] > 47) && (c.codeUnits[0] < 58)) {
    return true;
  } else {
    return false;
  }
}

bool is_operator(String c) {
  Iterable<String> simbols = simbologia.values;
  if (simbols.contains(c)) {
    return true;
  } else {
    return false;
  }
}

List<String> decompor(String? expression) {
  String valor1 = '', valor2 = '', op = '';
  int flag = 1, pass = 0;

  if (expression == null) {
    return [];
  }
  for (int i = 0; i < expression.length; i++) {
    if (flag == 1) {
      if ((is_digit(expression[i])) ||
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

  return [valor1, op, valor2];
}

void main() {
  List<String> content;
  String? expression = stdin.readLineSync();
  content = decompor(expression);
  print(content);
}
