// 2.1 — split('') quebra em caracteres, reversed inverte, join('') remonta.
String inverter(String frase) => frase.split('').reversed.join();

// 2.2 — Percorre uma vez, comparando em minúsculas e sem acento simplificado.
int contarVogais(String texto) {
  const vogais = 'aeiouáéíóúâêôãõà';
  var total = 0;
  for (final ch in texto.toLowerCase().split('')) {
    if (vogais.contains(ch)) total++;
  }
  return total;
}

// Versão funcional equivalente — mais curta e igualmente legível:
int contarVogais2(String texto) =>
    texto.toLowerCase().split('').where('aeiouáéíóúâêôãõà'.contains).length;

// 2.3 — O prefixo r cria uma "raw string": as barras invertidas não são
// interpretadas pelo Dart, e sim entregues cruas ao motor de regex.
final _regexEmail = RegExp(r'^[\w.\-+]+@[\w\-]+(\.[\w\-]+)+$');
bool emailValido(String email) => _regexEmail.hasMatch(email.trim());

// 2.4 — Máscara de CPF: mantém só os dígitos e insere a pontuação.
String formatarCpf(String entrada) {
  final d = entrada.replaceAll(RegExp(r'\D'), '');   // \D = tudo que não é dígito
  if (d.length != 11) throw FormatException('CPF deve ter 11 dígitos', entrada);
  return '${d.substring(0, 3)}.${d.substring(3, 6)}.'
         '${d.substring(6, 9)}-${d.substring(9)}';
}

// 2.5 — Iniciais: ignora preposições e pega a primeira letra de cada palavra.
String iniciais(String nomeCompleto) {
  const ignorar = {'de', 'da', 'do', 'das', 'dos', 'e'};
  return nomeCompleto
      .trim()
      .split(RegExp(r'\s+'))                      // \s+ trata espaços duplicados
      .where((p) => p.isNotEmpty && !ignorar.contains(p.toLowerCase()))
      .map((p) => p[0].toUpperCase())
      .join();
}

void main() {
  print(inverter('Flutter'));                  // rettulF
  print(contarVogais('Programação em Dart'));    // 7
  print(emailValido('aluno@ajudaprofessor.com.br')); // true
  print(emailValido('aluno@@teste'));            // false
  print(formatarCpf('12345678909'));             // 123.456.789-09
  print(iniciais('Carlos Adriani Lara Schaeffer')); // CALS
}