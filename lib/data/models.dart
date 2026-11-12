import 'package:material_ui/material_ui.dart';

/// Quem leva vantagem em um aspecto da comparação.
enum Vantagem { esquerda, direita, empate, depende }

/// Um exemplo de código curto, com a linguagem para rotular o bloco.
class Codigo {
  const Codigo({required this.linguagem, required this.fonte, this.legenda});

  final String linguagem;
  final String fonte;
  final String? legenda;
}

/// Um lado da comparação para um aspecto (ex.: como a Web resolve "layout").
class Lado {
  const Lado({
    required this.resumo,
    this.pontos = const [],
    this.codigo,
  });

  final String resumo;
  final List<String> pontos;
  final Codigo? codigo;
}

/// Um aspecto comparado (ex.: Renderização, Layout, Performance).
class Aspecto {
  const Aspecto({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.icone,
    required this.introducao,
    required this.esquerda,
    required this.direita,
    required this.vantagem,
    required this.veredito,
  });

  final String id;
  final String titulo;
  final String categoria;
  final IconData icone;
  final String introducao;
  final Lado esquerda;
  final Lado direita;
  final Vantagem vantagem;
  final String veredito;
}

/// Uma comparação completa entre duas tecnologias.
class Comparacao {
  const Comparacao({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.nomeEsquerda,
    required this.nomeDireita,
    required this.corEsquerda,
    required this.corDireita,
    required this.iconeEsquerda,
    required this.iconeDireita,
    required this.resumo,
    required this.aspectos,
    required this.escolhaEsquerdaQuando,
    required this.escolhaDireitaQuando,
  });

  final String id;
  final String titulo;
  final String subtitulo;
  final String nomeEsquerda;
  final String nomeDireita;
  final Color corEsquerda;
  final Color corDireita;
  final IconData iconeEsquerda;
  final IconData iconeDireita;
  final String resumo;
  final List<Aspecto> aspectos;
  final List<String> escolhaEsquerdaQuando;
  final List<String> escolhaDireitaQuando;

  List<String> get categorias {
    final vistas = <String>[];
    for (final a in aspectos) {
      if (!vistas.contains(a.categoria)) vistas.add(a.categoria);
    }
    return vistas;
  }

  int contar(Vantagem v) => aspectos.where((a) => a.vantagem == v).length;
}
