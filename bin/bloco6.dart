// 6.1 — Record para retornar (sucesso, mensagem) sem criar uma classe.
(bool sucesso, String mensagem) validarSenha(String senha) {
  if (senha.length < 8) return (false, 'A senha precisa de ao menos 8 caracteres');
  if (!senha.contains(RegExp(r'[0-9]'))) return (false, 'Inclua ao menos um número');
  if (!senha.contains(RegExp(r'[A-Z]'))) return (false, 'Inclua ao menos uma maiúscula');
  return (true, 'Senha forte');
}

// 6.2 — Classe sealed: o compilador conhece TODAS as subclasses possíveis,
// porque elas têm de estar no mesmo arquivo. Isso habilita switch exaustivo.
sealed class Resultado<T> {
  const Resultado();
}

final class Sucesso<T> extends Resultado<T> {
  final T dado;
  const Sucesso(this.dado);
}

final class Falha<T> extends Resultado<T> {
  final String mensagem;
  final int? codigo;
  const Falha(this.mensagem, {this.codigo});
}

Resultado<double> dividir(double a, double b) =>
    b == 0 ? const Falha('Divisão por zero', codigo: 400) : Sucesso(a / b);

String descrever(Resultado<double> r) => switch (r) {
  // Padrão de objeto: casa o tipo E extrai o campo em uma variável nova.
  Sucesso(dado: final v) => 'OK: ${v.toStringAsFixed(2)}',
  Falha(mensagem: final m, codigo: final c) => 'ERRO $c: $m',
  // Não precisa de "default": o compilador SABE que não há outro caso.
  // Se você criar uma terceira subclasse, este switch passa a dar erro
  // de compilação — que é exatamente o que você quer.
};

// 6.3 — Pattern matching desestruturando um "JSON" simulado.
String resumirResposta(Map<String, dynamic> json) {
  return switch (json) {
    // Casa se o mapa tiver 'status' == 'ok' e uma lista em 'itens'.
    {'status': 'ok', 'itens': List itens} =>
      '${itens.length} item(ns) recebido(s)',

    // Casa se houver um mapa aninhado em 'usuario' com nome e idade.
    {'usuario': {'nome': String nome, 'idade': int idade}} when idade >= 18 =>
      '$nome, maior de idade',

    {'usuario': {'nome': String nome}} => '$nome, menor de idade',

    {'erro': String msg} => 'Falhou: $msg',

    _ => 'Formato desconhecido',
  };
}

void main() {
  // Desestruturação do record direto na declaração:
  final (ok, msg) = validarSenha('abc');
  print('$ok -> $msg');   // false -> A senha precisa de ao menos 8 caracteres

  print(descrever(dividir(10, 4)));  // OK: 2.50
  print(descrever(dividir(10, 0)));  // ERRO 400: Divisão por zero

  print(resumirResposta({'status': 'ok', 'itens': [1, 2, 3]}));
  print(resumirResposta({'usuario': {'nome': 'Ana', 'idade': 22}}));
  print(resumirResposta({'erro': 'timeout'}));
}