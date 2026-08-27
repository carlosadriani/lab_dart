import 'dart:async';

// async* declara um "gerador assíncrono": a função devolve um Stream
// e cada "yield" emite um valor para quem estiver ouvindo.
Stream<int> contador({int de = 1, int ate = 5}) async* {
  for (var i = de; i <= ate; i++) {
    await Future.delayed(const Duration(milliseconds: 400));
    yield i;     // emite e continua vivo, ao contrário do return
  }
  // Quando a função termina, o stream é FECHADO automaticamente.
}

// Stream de progresso de um download simulado (0 a 100%).
Stream<double> progressoDownload() async* {
  for (var p = 0; p <= 100; p += 20) {
    await Future.delayed(const Duration(milliseconds: 250));
    yield p / 100;
  }
}

Future<void> consumirComAwaitFor() async {
  // await for pausa a cada evento e retoma no próximo. Legível como um for comum.
  await for (final n in contador(de: 1, ate: 5)) {
    print('tick $n');
  }
  print('stream encerrado');
}

Future<void> consumirComListen() async {
  final completador = Completer<void>();

  // listen NÃO bloqueia: registra callbacks e o código segue adiante.
  final assinatura = progressoDownload().listen(
    (p) => print('Baixando... ${(p * 100).toStringAsFixed(0)}%'),
    onError: (e) => print('Erro: $e'),
    onDone: () {
      print('Download concluído');
      completador.complete();
    },
  );

  await completador.future;
  // SEMPRE cancele a assinatura quando não precisar mais dela.
  // No Flutter, isso vai no dispose() — é a causa nº 1 de vazamento de memória.
  await assinatura.cancel();
}

// Transformações funcionam como em listas, mas de forma preguiçosa e assíncrona.
Future<void> transformando() async {
  final pares = await contador(de: 1, ate: 10)
      .where((n) => n.isEven)      // filtra
      .map((n) => n * n)            // transforma
      .take(3)                      // para depois de 3 eventos
      .toList();                    // junta tudo em uma List
  print(pares);                     // [4, 16, 36]
}

void main() async {
  await consumirComAwaitFor();
  await consumirComListen();
  await transformando();
}