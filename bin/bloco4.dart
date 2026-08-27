// 4.1 — Função de ordem superior: recebe OUTRA função como parâmetro.
// bool Function(T) é o tipo "função que recebe T e devolve bool".
List<T> filtrar<T>(List<T> itens, bool Function(T) criterio) {
  final saida = <T>[];
  for (final item in itens) {
    if (criterio(item)) saida.add(item);
  }
  return saida;
}

// 4.2 — Closure: a função devolvida "lembra" da variável total,
// mesmo depois que criarContador() já terminou. Cada chamada cria um estado novo.
int Function([int passo]) criarContador({int inicial = 0}) {
  var total = inicial;
  return ([int passo = 1]) {
    total += passo;
    return total;
  };
}

// 4.3 — typedef dá NOME a um tipo de função. Deixa a assinatura legível
// e é exatamente o que o Flutter faz com ValueChanged, VoidCallback etc.
typedef AoMudar<T> = void Function(T novoValor);

class CampoTexto {
  final String rotulo;
  final AoMudar<String>? aoMudar;   // pode ser nulo: nem todo campo reage
  CampoTexto(this.rotulo, {this.aoMudar});

  void digitar(String texto) {
    // ?.call(...) só executa se aoMudar não for nulo.
    aoMudar?.call(texto);
  }
}

// 4.4 — Memoização: guarda resultados já calculados em um Map (cache).
// Sem ela, fibonacci(40) recalcula bilhões de vezes os mesmos valores.
final Map<int, int> _cacheFib = {};

int fibonacci(int n) {
  if (n <= 1) return n;
  // putIfAbsent calcula só na primeira vez; nas seguintes devolve o cache.
  return _cacheFib.putIfAbsent(n, () => fibonacci(n - 1) + fibonacci(n - 2));
}

void main() {
  final numeros = [1, 4, 7, 10, 13, 16];
  print(filtrar(numeros, (n) => n % 2 == 0));       // [4, 10, 16]
  print(filtrar<String>(['ana', 'bo', 'carla'], (s) => s.length > 2)); // [ana, carla]

  final contador = criarContador(inicial: 10);
  print(contador());     // 11
  print(contador());     // 12
  print(contador(8));    // 20

  final outro = criarContador();
  print(outro());        // 1  -- estado independente do primeiro!

  final campo = CampoTexto('E-mail', aoMudar: (v) => print('digitou: $v'));
  campo.digitar('a@b.com');   // digitou: a@b.com

  print(fibonacci(50));  // 12586269025 -- instantâneo graças ao cache
}