import 'dart:math';   // para as funções max e min

// 3.1 — Um record nomeado devolve as três estatísticas de uma vez.
({double media, double maior, double menor}) estatisticas(List<double> notas) {
  if (notas.isEmpty) throw ArgumentError('A lista de notas está vazia');
  // fold percorre acumulando: começa em 0.0 e vai somando.
  final soma = notas.fold<double>(0, (acc, n) => acc + n);
  return (
    media: soma / notas.length,
    maior: notas.reduce(max),   // reduce compara par a par usando max
    menor: notas.reduce(min),
  );
}

// 3.2 — toSet() remove duplicados, mas a ordem do Set NÃO é garantida em geral.
// LinkedHashSet (que é o Set padrão do Dart) preserva a ordem de inserção,
// então na prática este toSet().toList() funciona — e é o idioma mais usado.
List<T> semDuplicados<T>(List<T> itens) => itens.toSet().toList();

// Versão explícita, sem depender do detalhe de implementação:
List<T> semDuplicadosOrdenado<T>(List<T> itens) {
  final vistos = <T>{};
  final saida = <T>[];
  for (final item in itens) {
    // add() devolve false se o elemento já existia no Set.
    if (vistos.add(item)) saida.add(item);
  }
  return saida;
}

// 3.3 — Agrupamento manual com putIfAbsent: o idioma mais direto em Dart puro.
Map<String, List<String>> agruparPorTurma(List<(String nome, String turma)> alunos) {
  final mapa = <String, List<String>>{};
  for (final (nome, turma) in alunos) {   // desestrutura o record no for
    // putIfAbsent cria a lista na primeira vez e devolve a existente depois.
    mapa.putIfAbsent(turma, () => []).add(nome);
  }
  return mapa;
}

void main() {
  final e = estatisticas([7.5, 9.0, 4.5, 8.0]);
  print('Média ${e.media.toStringAsFixed(2)} | maior ${e.maior} | menor ${e.menor}');

  print(semDuplicadosOrdenado(['a', 'b', 'a', 'c', 'b']));  // [a, b, c]

  final turmas = agruparPorTurma([
    ('Ana', 'ADS-3A'), ('Bruno', 'ADS-3B'), ('Carla', 'ADS-3A'),
  ]);
  turmas.forEach((turma, nomes) => print('$turma: ${nomes.join(", ")}'));
  // ADS-3A: Ana, Carla
  // ADS-3B: Bruno
}