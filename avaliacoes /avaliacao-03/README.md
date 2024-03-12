# RESULTADOS DO CÓDIGO:

![image](https://github.com/mareshbard/PDM2-24-1/assets/125154278/c7a1a605-638c-41f2-83b6-16aee7a849dc)


## Feito em dupla com Letícia Vitória

# CÓDIGO:
~~~
import 'dart:io';
import 'dart:async';
import 'dart:isolate';

void main() async {
String aluno1 = 'Antonio Abner Soares Jeronimo';
String aluno2 = 'Letícia Vitória Pereira Gomes';
print('Atividade feita por ' + aluno1 + ' e ' + aluno2);

  final receivePort = ReceivePort();
  await Isolate.spawn(doAsyncOperation, receivePort.sendPort);

  print('Iniciando outras tarefas...');
  await Future.delayed(Duration(seconds: 1));
  print('Continuando outras tarefas...');

  final result = await receivePort.first;
  print('Resultado: $result');
}

void doAsyncOperation(SendPort sendPort) async {
  final result = await File('./16-programacao-assincrona/arquivo.txt').readAsString();
  sendPort.send(result);
}

~~~
# LAUNCH JSON:

![image](https://github.com/mareshbard/PDM2-24-1/assets/125154278/0e8314e3-e2ab-4ce4-8487-1429c2f60e4f)

