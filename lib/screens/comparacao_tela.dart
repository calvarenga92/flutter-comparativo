import 'package:material_ui/material_ui.dart';

import '../data/models.dart';
import '../theme/estilo.dart';
import '../widgets/comuns.dart';
import 'aspecto_tela.dart';

class ComparacaoTela extends StatefulWidget {
  const ComparacaoTela({super.key, required this.comparacao, required this.numero});

  final Comparacao comparacao;
  final String numero;

  @override
  State<ComparacaoTela> createState() => _ComparacaoTelaState();
}

class _ComparacaoTelaState extends State<ComparacaoTela> {
  String? _categoria;
  String _busca = '';

  List<Aspecto> get _filtrados {
    final termo = _busca.trim().toLowerCase();
    return widget.comparacao.aspectos.where((a) {
      if (_categoria != null && a.categoria != _categoria) return false;
      if (termo.isEmpty) return true;
      final texto = [
        a.titulo,
        a.introducao,
        a.esquerda.resumo,
        a.direita.resumo,
        ...a.esquerda.pontos,
        ...a.direita.pontos,
      ].join(' ').toLowerCase();
      return texto.contains(termo);
    }).toList();
  }

  void _abrir(Aspecto a) => Navigator.of(context).push(rotaAspecto(
        context: context,
        comparacao: widget.comparacao,
        indice: widget.comparacao.aspectos.indexOf(a),
      ));

  @override
  Widget build(BuildContext context) {
    final c = widget.comparacao;
    final w = MediaQuery.sizeOf(context).width;
    final filtrados = _filtrados;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Conteudo(
            child: Padding(
              padding: EdgeInsets.only(top: w < 600 ? 56 : 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow('Comparação ${widget.numero}'),
                  const SizedBox(height: 28),
                  TituloVersus(comparacao: c, estilo: Tipo.display(w)),
                  const SizedBox(height: 36),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: Text(c.resumo, style: Tipo.lead),
                  ),
                  const SizedBox(height: 64),
                  _Placar(comparacao: c),
                  const SizedBox(height: 96),
                  CabecalhoSecao(
                    numero: '01',
                    rotulo: 'Aspectos',
                    titulo: 'Ponto a ponto.',
                    descricao: 'Filtre por categoria ou busque um tema. '
                        'Clique em um aspecto para ver os dois lados completos, com código.',
                  ),
                  const SizedBox(height: 40),
                  _Filtros(
                    categorias: c.categorias,
                    selecionada: _categoria,
                    aoBuscar: (v) => setState(() => _busca = v),
                    aoSelecionar: (cat) => setState(() => _categoria = cat),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
        if (filtrados.isEmpty)
          SliverToBoxAdapter(
            child: Conteudo(
              vertical: 64,
              child: Text('Nenhum aspecto encontrado para "$_busca".', style: Tipo.lead),
            ),
          )
        else
          SliverList.builder(
            itemCount: filtrados.length,
            itemBuilder: (context, i) {
              final a = filtrados[i];
              return Conteudo(
                child: _LinhaAspecto(
                  numero: (c.aspectos.indexOf(a) + 1).toString().padLeft(2, '0'),
                  aspecto: a,
                  comparacao: c,
                  onTap: () => _abrir(a),
                ),
              );
            },
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 140),
            child: Conteudo(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CabecalhoSecao(numero: '02', rotulo: 'Decisão', titulo: 'Quando escolher\ncada um.'),
                  const SizedBox(height: 56),
                  _QuandoEscolher(comparacao: c),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: Rodape()),
      ],
    );
  }
}

// ─────────────────────────── Placar ───────────────────────────

class _Placar extends StatelessWidget {
  const _Placar({required this.comparacao});

  final Comparacao comparacao;

  @override
  Widget build(BuildContext context) {
    final c = comparacao;
    final itens = [
      (c.contar(Vantagem.esquerda), 'Vantagem ${c.nomeEsquerda}', c.corEsquerda),
      (c.contar(Vantagem.direita), 'Vantagem ${c.nomeDireita}', c.corDireita),
      (c.contar(Vantagem.empate), 'Empate', Paleta.textoSuave),
      (c.contar(Vantagem.depende), 'Depende do projeto', Paleta.destaque),
    ];
    return LayoutBuilder(builder: (context, k) {
      final colunas = k.maxWidth < 640 ? 2 : 4;
      final largura = k.maxWidth / colunas;
      return Wrap(children: [
        for (final (n, rotulo, cor) in itens)
          Container(
            width: largura,
            padding: const EdgeInsets.only(top: 20, bottom: 20, right: 16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: cor, width: 2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontFamily: Fontes.titulo,
                      fontWeight: FontWeight.w700,
                      fontSize: 56,
                      height: 1,
                      letterSpacing: -2,
                      color: cor,
                    )),
                const SizedBox(height: 10),
                Text(rotulo.toUpperCase(), style: Tipo.rotulo),
              ],
            ),
          ),
      ]);
    });
  }
}

// ─────────────────────────── Filtros ───────────────────────────

class _Filtros extends StatelessWidget {
  const _Filtros({
    required this.categorias,
    required this.selecionada,
    required this.aoBuscar,
    required this.aoSelecionar,
  });

  final List<String> categorias;
  final String? selecionada;
  final ValueChanged<String> aoBuscar;
  final ValueChanged<String?> aoSelecionar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: aoBuscar,
          style: const TextStyle(fontFamily: Fontes.titulo, fontSize: 24, fontWeight: FontWeight.w500),
          decoration: const InputDecoration(
            hintText: 'Buscar: SEO, Bluetooth, hot reload...',
            hintStyle: TextStyle(color: Paleta.textoSuave),
            prefixIcon: Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.search, color: Paleta.textoSuave),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 36),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Paleta.borda)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Paleta.destaque, width: 2)),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Pilula(rotulo: 'Todas', ativa: selecionada == null, onTap: () => aoSelecionar(null)),
            for (final cat in categorias)
              _Pilula(rotulo: cat, ativa: selecionada == cat, onTap: () => aoSelecionar(cat)),
          ],
        ),
      ],
    );
  }
}

class _Pilula extends StatelessWidget {
  const _Pilula({required this.rotulo, required this.ativa, required this.onTap});

  final String rotulo;
  final bool ativa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: ativa,
      child: Hover(
        onTap: onTap,
        builder: (context, emCima) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: ativa ? Paleta.texto : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: ativa || emCima ? Paleta.texto : Paleta.borda),
          ),
          child: Text(
            rotulo,
            style: TextStyle(
              color: ativa ? Paleta.sobreDestaque : Paleta.texto,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Linha de aspecto ───────────────────────────

class _LinhaAspecto extends StatelessWidget {
  const _LinhaAspecto({
    required this.numero,
    required this.aspecto,
    required this.comparacao,
    required this.onTap,
  });

  final String numero;
  final Aspecto aspecto;
  final Comparacao comparacao;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final a = aspecto;
    final c = comparacao;
    final w = MediaQuery.sizeOf(context).width;
    final largo = w >= 900;

    Widget lado(String nome, Color cor, String texto) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(nome.toUpperCase(), style: Tipo.rotulo.copyWith(color: cor, fontSize: 11)),
            ]),
            const SizedBox(height: 8),
            Text(texto,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Paleta.textoSuave, height: 1.55)),
          ],
        );

    return Semantics(
      button: true,
      label: a.titulo,
      child: Hover(
        onTap: onTap,
        builder: (context, emCima) {
          final titulo = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: Fontes.titulo,
                  fontWeight: FontWeight.w700,
                  fontSize: largo ? 30 : 26,
                  height: 1.1,
                  letterSpacing: -0.8,
                  color: emCima ? Paleta.destaque : Paleta.texto,
                ),
                child: Text(a.titulo),
              ),
              const SizedBox(height: 10),
              Text(a.categoria.toUpperCase(), style: Tipo.rotulo.copyWith(fontSize: 11)),
              const SizedBox(height: 14),
              SeloVantagem(aspecto: a, comparacao: c),
            ],
          );

          final previa = largo
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: lado(c.nomeEsquerda, c.corEsquerda, a.esquerda.resumo)),
                  const SizedBox(width: 28),
                  Expanded(child: lado(c.nomeDireita, c.corDireita, a.direita.resumo)),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  lado(c.nomeEsquerda, c.corEsquerda, a.esquerda.resumo),
                  const SizedBox(height: 16),
                  lado(c.nomeDireita, c.corDireita, a.direita.resumo),
                ]);

          final seta = AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            offset: Offset(emCima ? 0.2 : 0, 0),
            child: Icon(Icons.arrow_forward, color: emCima ? Paleta.destaque : Paleta.textoSuave),
          );

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 36),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Paleta.borda)),
            ),
            child: largo
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 64, child: Text(numero, style: Tipo.rotulo)),
                      Expanded(flex: 4, child: titulo),
                      const SizedBox(width: 40),
                      Expanded(flex: 7, child: previa),
                      const SizedBox(width: 32),
                      seta,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Text(numero, style: Tipo.rotulo), const Spacer(), seta]),
                      const SizedBox(height: 12),
                      titulo,
                      const SizedBox(height: 20),
                      previa,
                    ],
                  ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────── Quando escolher ───────────────────────────

class _QuandoEscolher extends StatelessWidget {
  const _QuandoEscolher({required this.comparacao});

  final Comparacao comparacao;

  @override
  Widget build(BuildContext context) {
    final c = comparacao;
    Widget bloco(String nome, Color cor, List<String> itens) => Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Paleta.superficie,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Paleta.borda),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ESCOLHA', style: Tipo.rotulo.copyWith(color: cor)),
            const SizedBox(height: 8),
            Text(nome,
                style: TextStyle(
                  fontFamily: Fontes.titulo,
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                  letterSpacing: -1.2,
                  color: cor,
                )),
            const SizedBox(height: 4),
            const Text('quando...', style: TextStyle(color: Paleta.textoSuave, fontSize: 16)),
            const SizedBox(height: 24),
            ListaPontos(pontos: itens, cor: cor),
          ]),
        );

    return LayoutBuilder(builder: (context, k) {
      final esq = bloco(c.nomeEsquerda, c.corEsquerda, c.escolhaEsquerdaQuando);
      final dir = bloco(c.nomeDireita, c.corDireita, c.escolhaDireitaQuando);
      if (k.maxWidth < 800) {
        return Column(children: [esq, const SizedBox(height: 16), dir]);
      }
      return IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: esq),
          const SizedBox(width: 16),
          Expanded(child: dir),
        ]),
      );
    });
  }
}
