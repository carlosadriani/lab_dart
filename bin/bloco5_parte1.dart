// 5.1 — Uma classe imutável de domínio.
class Produto {
  final String id;
  final String nome;
  final double preco;

  // Construtor com parâmetros nomeados obrigatórios: chamada autoexplicativa.
  const Produto({required this.id, required this.nome, required this.preco});

  // toString é chamado automaticamente por print() e por interpolação.
  @override
  String toString() => 'Produto($nome, R\$ ${preco.toStringAsFixed(2)})';

  // Igualdade por VALOR: dois produtos com o mesmo id são "o mesmo produto".
  // Sem isso, list.contains() e Set usariam identidade de objeto e falhariam.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Produto && other.id == id);

  // REGRA: se você sobrescreve ==, DEVE sobrescrever hashCode de forma coerente.
  @override
  int get hashCode => id.hashCode;
}

class ItemPedido {
  final Produto produto;
  int quantidade;
  ItemPedido(this.produto, [this.quantidade = 1]);

  // Getter calculado: não ocupa memória, é recalculado a cada leitura.
  double get subtotal => produto.preco * quantidade;
}

class Carrinho {
  // A lista é privada para o mundo externo não conseguir alterá-la por fora.
  final List<ItemPedido> _itens = [];

  // Exponho uma visão SOMENTE LEITURA. Quem chamar não consegue dar .add().
  List<ItemPedido> get itens => List.unmodifiable(_itens);

  double get total => _itens.fold<double>(0, (t, i) => t + i.subtotal);
  int get quantidadeTotal => _itens.fold<int>(0, (t, i) => t + i.quantidade);
  bool get vazio => _itens.isEmpty;

  void adicionar(Produto p, [int qtd = 1]) {
    // Se o produto já está no carrinho, incrementa em vez de duplicar a linha.
    // indexWhere devolve -1 quando não encontra — sem depender de pacotes extras.
    final pos = _itens.indexWhere((i) => i.produto == p);
    if (pos != -1) {
      final existente = _itens[pos];
      existente.quantidade += qtd;
    } else {
      _itens.add(ItemPedido(p, qtd));
    }
  }

  void remover(Produto p) => _itens.removeWhere((i) => i.produto == p);
  void limpar() => _itens.clear();
}

enum StatusPedido { aberto, pago, enviado, entregue, cancelado }

class Pedido {
  final String numero;
  final Carrinho carrinho;
  final DateTime criadoEm;
  StatusPedido status;

  // Inicializador com valor padrão calculado em tempo de execução.
  Pedido({required this.numero, required this.carrinho, DateTime? criadoEm})
      : criadoEm = criadoEm ?? DateTime.now(),
        status = StatusPedido.aberto;

  double get valorTotal => carrinho.total;

  @override
  String toString() =>
      'Pedido #$numero (${status.name}) - R\$ ${valorTotal.toStringAsFixed(2)}';
}

void main() {
  const caderno = Produto(id: 'p1', nome: 'Caderno', preco: 24.90);
  const caneta  = Produto(id: 'p2', nome: 'Caneta',  preco: 3.50);

  final c = Carrinho()
    ..adicionar(caderno, 2)
    ..adicionar(caneta, 5)
    ..adicionar(caderno);      // vira 3 cadernos, não uma linha nova

  print('${c.quantidadeTotal} itens, total R\$ ${c.total.toStringAsFixed(2)}');
  print(Pedido(numero: '2026-001', carrinho: c));
}