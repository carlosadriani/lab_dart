// 5.2 — Herança: Aluno e Professor SÃO pessoas, com dados e comportamento próprios.
abstract class Pessoa {
  final String nome;
  final DateTime nascimento;
  Pessoa({required this.nome, required this.nascimento});

  int get idade {
    final hoje = DateTime.now();
    var anos = hoje.year - nascimento.year;
    // Ainda não fez aniversário este ano? Então tem um ano a menos.
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      anos--;
    }
    return anos;
  }

  // Método abstrato: cada subclasse é OBRIGADA a implementar.
  String apresentar();
}

// 5.3 — Mixin: comportamento reutilizável, sem herança múltipla de estado.
// "on Object" não é necessário aqui, mas você pode restringir com "mixin X on Y".
mixin Auditavel {
  final List<String> _log = [];
  List<String> get historico => List.unmodifiable(_log);

  void registrar(String acao) {
    _log.add('[${DateTime.now().toIso8601String()}] $acao');
  }
}

class Aluno extends Pessoa with Auditavel {
  final String matricula;
  final List<double> notas;

  Aluno({
    required super.nome,          // super. encaminha direto ao construtor da superclasse
    required super.nascimento,
    required this.matricula,
    List<double>? notas,
  }) : notas = notas ?? [];

  double get media =>
      notas.isEmpty ? 0 : notas.reduce((a, b) => a + b) / notas.length;

  bool get aprovado => media >= 7.0;

  void lancarNota(double n) {
    notas.add(n);
    registrar('Nota $n lançada para $matricula');   // veio do mixin
  }

  @override
  String apresentar() => 'Aluno $nome ($matricula), média ${media.toStringAsFixed(1)}';
}

class Professor extends Pessoa with Auditavel {
  final String titulacao;
  final List<String> disciplinas;

  Professor({
    required super.nome,
    required super.nascimento,
    required this.titulacao,
    this.disciplinas = const [],
  });

  @override
  String apresentar() => 'Prof. $titulacao $nome — ${disciplinas.join(", ")}';
}

// 5.4 — Extension: adiciona métodos a um tipo que você NÃO controla.
extension TextoBonito on String {
  String get capitalizado {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  // Capitaliza cada palavra: "maria da silva" -> "Maria Da Silva"
  String get titulo =>
      split(' ').map((p) => p.capitalizado).join(' ');
}

void main() {
  final ana = Aluno(
    nome: 'Ana Souza',
    nascimento: DateTime(2004, 3, 12),
    matricula: '2026001',
  );
  ana..lancarNota(8.5)..lancarNota(6.0);

  print(ana.apresentar());          // Aluno Ana Souza (2026001), média 7.2
  print('Idade: ${ana.idade}');
  print('Aprovada? ${ana.aprovado}');
  print(ana.historico.length);      // 2 -- o mixin registrou as duas notas

  print('joão pedro'.titulo);       // João Pedro
}