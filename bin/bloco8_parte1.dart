// Simula uma chamada de rede que demora e devolve um texto.
import 'dart:async';

Future<String> buscarRecurso(String nome, int ms) async {
  // Future.delayed espera SEM travar a thread: o event loop segue livre.
  await Future.delayed(Duration(milliseconds: ms));
  return '$nome (${ms}ms)';
}

Future<void> emSequencia() async {
  final cronometro = Stopwatch()..start();

  // Cada await BLOQUEIA o fluxo desta função até o Future completar.
  // Total = 300 + 500 + 400 = ~1200 ms
  final a = await buscarRecurso('perfil', 300);
  final b = await buscarRecurso('pedidos', 500);
  final c = await buscarRecurso('notificacoes', 400);

  cronometro.stop();
  print('Sequência: [$a, $b, $c] em ${cronometro.elapsedMilliseconds}ms');
}

Future<void> emParalelo() async {
  final cronometro = Stopwatch()..start();

  // AQUI está o segredo: as três chamadas são DISPARADAS antes de qualquer
  // await. Future.wait espera todas terminarem juntas.
  // Total = max(300, 500, 400) = ~500 ms
  final resultados = await Future.wait([
    buscarRecurso('perfil', 300),
    buscarRecurso('pedidos', 500),
    buscarRecurso('notificacoes', 400),
  ]);

  cronometro.stop();
  print('Paralelo: $resultados em ${cronometro.elapsedMilliseconds}ms');
}

// Tratamento de erro: try / catch / finally funcionam normalmente com await.
Future<String> buscarComFalha() async {
  await Future.delayed(const Duration(milliseconds: 200));
  throw Exception('Servidor indisponível (503)');
}

Future<void> comTratamento() async {
  try {
    final r = await buscarComFalha().timeout(const Duration(seconds: 2));
    print(r);
  } on TimeoutException {
    print('Demorou demais — tente novamente');
  } catch (e) {
    // Mensagem para o usuário, não o stack trace cru.
    print('Não foi possível carregar: $e');
  } finally {
    // Roda com erro ou sem erro: ideal para desligar o "carregando...".
    print('Fim da tentativa');
  }
}

void main() async {
  await emSequencia();   // ~1200ms
  await emParalelo();    // ~500ms  <- mesma informação, 2,4x mais rápido
  await comTratamento();
}