double celsiusParaFahrenheit(double c) => c * 9 / 5 + 32;
double fahrenheitParaCelsius(double f) => (f - 32) * 5 / 9;

// 1.2 — Retorna um registro (record) com o valor e a classificação.
// Records existem desde o Dart 3 e evitam criar uma classe só para devolver 2 valores.
({double imc, String classe}) calcularImc(double pesoKg, double alturaM) {
  final imc = pesoKg / (alturaM * alturaM);
  // switch expression com padrões relacionais (Dart 3): lê-se de cima para baixo.
  final classe = switch (imc) {
    < 18.5 => 'Magreza',
    < 25   => 'Peso normal',
    < 30   => 'Sobrepeso',
    < 35   => 'Obesidade grau I',
    < 40   => 'Obesidade grau II',
    _      => 'Obesidade grau III',   // _ é o caso padrão (obrigatório aqui)
  };
  return (imc: imc, classe: classe);
}

// 1.3 — A regra completa do calendário gregoriano.
bool ehBissexto(int ano) =>
    ano % 4 == 0 && (ano % 100 != 0 || ano % 400 == 0);

// 1.4 — padLeft alinha à direita preenchendo com espaços.
void imprimirTabuada(int n) {
  for (var i = 1; i <= 10; i++) {
    final produto = n * i;
    print('$n x ${i.toString().padLeft(2)} = ${produto.toString().padLeft(3)}');
  }
}

void main() {
  print('--- Temperaturas ---');
  for (var c = -10; c <= 40; c += 10) {
    // toStringAsFixed(1) formata com exatamente uma casa decimal.
    print('${c.toString().padLeft(3)} C = '
          '${celsiusParaFahrenheit(c.toDouble()).toStringAsFixed(1)} F');
  }

  print('\n--- IMC ---');
  final r = calcularImc(78, 1.75);
  // Acesso aos campos nomeados do record: r.imc e r.classe
  print('IMC ${r.imc.toStringAsFixed(1)} -> ${r.classe}');

  print('\n--- Bissextos ---');
  for (final ano in [1900, 2000, 2024, 2026]) {
    print('$ano: ${ehBissexto(ano) ? "bissexto" : "comum"}');
  }

  print('\n--- Tabuada do 7 ---');
  imprimirTabuada(7);
}