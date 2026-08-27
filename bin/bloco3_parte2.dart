// 3.4 — Ordenar uma lista de mapas por turma (A-Z) e, dentro dela, por nota (maior primeiro).
void exemploOrdenacao() {
  final alunos = [
    {'nome': 'Ana',   'turma': 'B', 'nota': 8.0},
    {'nome': 'Bruno', 'turma': 'A', 'nota': 6.5},
    {'nome': 'Carla', 'turma': 'A', 'nota': 9.2},
  ];

  // sort() ordena EM ORDEM (in place) e devolve void — cuidado, ele altera a lista.
  alunos.sort((a, b) {
    // 1º critério: turma em ordem alfabética.
    final porTurma = (a['turma'] as String).compareTo(b['turma'] as String);
    // Se as turmas são diferentes, já decidimos. Se empatou (0), vamos ao 2º critério.
    if (porTurma != 0) return porTurma;
    // 2º critério: nota decrescente — note a ordem invertida (b antes de a).
    return (b['nota'] as double).compareTo(a['nota'] as double);
  });

  // Atenção: dentro de uma interpolação, não repita o mesmo tipo de aspas.
  // Extraia para variáveis — fica válido e muito mais legível.
  for (final a in alunos) {
    final turma = a['turma'];
    final nome  = a['nome'];
    final nota  = a['nota'];
    print('$turma | $nome | $nota');
  }
  // A | Carla | 9.2
  // A | Bruno | 6.5
  // B | Ana   | 8.0
}

// 3.5 — Carrinho: soma de preço x quantidade com fold.
class ItemCarrinho {
  final String nome;
  final double preco;
  final int quantidade;
  const ItemCarrinho(this.nome, this.preco, this.quantidade);

  double get subtotal => preco * quantidade;
}

double totalDoCarrinho(List<ItemCarrinho> itens) =>
    itens.fold<double>(0, (total, item) => total + item.subtotal);

void main() {
  exemploOrdenacao();

  final carrinho = [
    const ItemCarrinho('Caderno', 24.90, 2),
    const ItemCarrinho('Caneta', 3.50, 5),
    const ItemCarrinho('Mochila', 189.00, 1),
  ];
  print('Total: R\$ ${totalDoCarrinho(carrinho).toStringAsFixed(2)}');
  // Total: R$ 256.30

  // Bônus: os 2 itens mais caros, do maior para o menor.
  final maisCaros = [...carrinho]                   // cópia: não altera o original
    ..sort((a, b) => b.subtotal.compareTo(a.subtotal)); // .. = cascade
  print(maisCaros.take(2).map((i) => i.nome).toList()); // [Mochila, Caderno]
}