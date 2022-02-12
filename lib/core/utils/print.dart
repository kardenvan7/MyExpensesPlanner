void printWithBrackets(Object? object, {int bracketsCount = 60}) {
  print('(' * bracketsCount);
  print(object.toString());
  print(')' * bracketsCount);
}
