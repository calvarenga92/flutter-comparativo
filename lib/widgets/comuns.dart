import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../data/models.dart';
import '../theme/estilo.dart';

// ─────────────────────────── Navegação ───────────────────────────

/// Expõe a troca de página para qualquer widget abaixo da casca do app.
class Navegacao extends InheritedWidget {
  const Navegacao({super.key, required this.ir, required this.atual, required super.child});

  final ValueChanged<int> ir;
  final int atual;

  static Navegacao of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Navegacao>()!;

  @override
  bool updateShouldNotify(Navegacao old) => old.atual != atual;
}

// ─────────────────────────── Layout ───────────────────────────

double margemLateral(double largura) =>
    largura < 600 ? 20 : (largura < 1100 ? 40 : 64);

/// Conteúdo com largura máxima e margens laterais responsivas.
class Conteudo extends StatelessWidget {
  const Conteudo({super.key, required this.child, this.largura = 1280, this.vertical = 0});

  final Widget child;
  final double largura;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margemLateral(w), vertical: vertical),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: largura),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────── Interação ───────────────────────────

/// Reconstrói o filho conforme o mouse está ou não sobre ele.
class Hover extends StatefulWidget {
  const Hover({super.key, required this.builder, this.onTap});

  final Widget Function(BuildContext context, bool emCima) builder;
  final VoidCallback? onTap;

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  bool _emCima = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _emCima = true),
      onExit: (_) => setState(() => _emCima = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: widget.builder(context, _emCima),
      ),
    );
  }
}

/// Botão em formato de pílula; [cheio] usa a cor de destaque.
class BotaoPill extends StatelessWidget {
  const BotaoPill({
    super.key,
    required this.rotulo,
    required this.onTap,
    this.cheio = true,
    this.icone = Icons.arrow_outward,
  });

  final String rotulo;
  final VoidCallback onTap;
  final bool cheio;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: rotulo,
      child: Hover(
        onTap: onTap,
        builder: (context, emCima) {
          final fundo = cheio
              ? (emCima ? Paleta.texto : Paleta.destaque)
              : (emCima ? Paleta.texto : Colors.transparent);
          final frente = cheio || emCima ? Paleta.sobreDestaque : Paleta.texto;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            decoration: BoxDecoration(
              color: fundo,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: cheio ? fundo : Paleta.texto.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(rotulo,
                      style: TextStyle(color: frente, fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                if (icone != null) ...[
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: emCima ? 0.125 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(icone, size: 18, color: frente),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────── Tipografia ───────────────────────────

/// Rótulo pequeno em caixa alta, com um ponto de destaque.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.texto, {super.key, this.cor = Paleta.destaque});

  final String texto;
  final Color cor;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Flexible(child: Text(texto.toUpperCase(), style: Tipo.rotulo)),
        ],
      );
}

/// Cabeçalho de seção: "01 — Rótulo", título grande e descrição opcional ao lado.
class CabecalhoSecao extends StatelessWidget {
  const CabecalhoSecao({
    super.key,
    required this.numero,
    required this.rotulo,
    required this.titulo,
    this.descricao,
  });

  final String numero;
  final String rotulo;
  final String titulo;
  final String? descricao;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cabeca = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow('$numero — $rotulo'),
        const SizedBox(height: 20),
        Text(titulo, style: Tipo.tituloSecao(w)),
      ],
    );
    if (descricao == null) return cabeca;
    final desc = Text(descricao!, style: Tipo.lead.copyWith(fontSize: 17));
    if (w < 900) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [cabeca, const SizedBox(height: 20), desc],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(flex: 3, child: cabeca),
        const SizedBox(width: 64),
        Expanded(flex: 2, child: desc),
      ],
    );
  }
}

/// Título de duas tecnologias com as cores de cada uma: "Web × Flutter".
class TituloVersus extends StatelessWidget {
  const TituloVersus({super.key, required this.comparacao, required this.estilo});

  final Comparacao comparacao;
  final TextStyle estilo;

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(style: estilo, children: [
          TextSpan(text: comparacao.nomeEsquerda, style: TextStyle(color: comparacao.corEsquerda)),
          const TextSpan(text: ' × ', style: TextStyle(color: Paleta.textoSuave)),
          TextSpan(text: comparacao.nomeDireita, style: TextStyle(color: comparacao.corDireita)),
        ]),
      );
}

// ─────────────────────────── Peças de conteúdo ───────────────────────────

/// Bloco de código monoespaçado com rótulo da linguagem e botão de copiar.
class BlocoCodigo extends StatelessWidget {
  const BlocoCodigo({super.key, required this.codigo});

  final Codigo codigo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF07070A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Paleta.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Paleta.borda)),
            ),
            child: Row(
              children: [
                for (final c in const [Color(0xFFFF5F57), Color(0xFFFEBC2E), Color(0xFF28C840)])
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                const SizedBox(width: 10),
                Text(codigo.linguagem.toUpperCase(), style: Tipo.rotulo.copyWith(fontSize: 11)),
                const Spacer(),
                IconButton(
                  tooltip: 'Copiar',
                  iconSize: 16,
                  color: Paleta.textoSuave,
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: codigo.fonte));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado')),
                    );
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(18),
            child: SelectableText(
              codigo.fonte,
              style: const TextStyle(
                fontFamily: Fontes.mono,
                fontSize: 13,
                height: 1.6,
                color: Color(0xFFD7D5E0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pílula dizendo quem leva vantagem num aspecto.
class SeloVantagem extends StatelessWidget {
  const SeloVantagem({super.key, required this.aspecto, required this.comparacao});

  final Aspecto aspecto;
  final Comparacao comparacao;

  @override
  Widget build(BuildContext context) {
    final (texto, cor) = switch (aspecto.vantagem) {
      Vantagem.esquerda => ('Vantagem ${comparacao.nomeEsquerda}', comparacao.corEsquerda),
      Vantagem.direita => ('Vantagem ${comparacao.nomeDireita}', comparacao.corDireita),
      Vantagem.empate => ('Empate', Paleta.textoSuave),
      Vantagem.depende => ('Depende do projeto', Paleta.destaque),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cor.withValues(alpha: 0.5)),
        color: cor.withValues(alpha: 0.08),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(texto.toUpperCase(), style: Tipo.rotulo.copyWith(fontSize: 10.5, color: cor)),
      ]),
    );
  }
}

/// Lista com marcadores em seta.
class ListaPontos extends StatelessWidget {
  const ListaPontos({super.key, required this.pontos, this.cor = Paleta.destaque});

  final List<String> pontos;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in pontos)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Paleta.borda)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3, right: 12),
                  child: Icon(Icons.arrow_forward, size: 15, color: cor),
                ),
                Expanded(child: Text(p, style: const TextStyle(height: 1.5))),
              ],
            ),
          ),
      ],
    );
  }
}

/// Faixa de palavras-chave rolando sem parar.
class Marquee extends StatefulWidget {
  const Marquee({super.key, required this.itens});

  final List<String> itens;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 40))..repeat();

  static const _estilo = TextStyle(
    fontFamily: Fontes.titulo,
    fontWeight: FontWeight.w700,
    fontSize: 34,
    letterSpacing: -0.5,
    color: Paleta.texto,
  );

  String get _sequencia => '${widget.itens.join('  ✦  ')}  ✦  ';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medida = TextPainter(
      text: TextSpan(text: _sequencia, style: _estilo),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    final larguraUm = medida.width;

    return Container(
      height: 84,
      decoration: const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Paleta.borda)),
      ),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) => OverflowBox(
            alignment: Alignment.centerLeft,
            maxWidth: double.infinity,
            child: Transform.translate(
              offset: Offset(-_ctrl.value * larguraUm, 0),
              child: Text(_sequencia * 4, maxLines: 1, softWrap: false, style: _estilo),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Rodapé ───────────────────────────

class Rodape extends StatelessWidget {
  const Rodape({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final nav = Navegacao.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 120),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Paleta.borda)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Conteudo(
            vertical: 96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Ainda em dúvida?'),
                const SizedBox(height: 24),
                Text('Descubra qual tecnologia\ncombina com o seu projeto.',
                    style: Tipo.display(w, min: 36, max: 84)),
                const SizedBox(height: 36),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  BotaoPill(rotulo: 'Fazer o teste', onTap: () => nav.ir(4)),
                  BotaoPill(rotulo: 'Ver a tabela', cheio: false, onTap: () => nav.ir(3)),
                ]),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Paleta.borda)),
            ),
            child: Conteudo(
              vertical: 32,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: [
                  const Marca(),
                  Text(
                    'Feito por Claudio Alvarenga, em Flutter. Cada pixel desta página foi desenhado pelo motor do Flutter, não pelo DOM.',
                    style: Tipo.rotulo.copyWith(letterSpacing: 0.4),
                  ),
                  Text('© 2026', style: Tipo.rotulo),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logotipo em texto: "comparativo." com o ponto em destaque.
class Marca extends StatelessWidget {
  const Marca({super.key, this.tamanho = 22});

  final double tamanho;

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(
          style: TextStyle(
            fontFamily: Fontes.titulo,
            fontWeight: FontWeight.w700,
            fontSize: tamanho,
            letterSpacing: -0.8,
            color: Paleta.texto,
          ),
          children: const [
            TextSpan(text: 'comparativo'),
            TextSpan(text: '.', style: TextStyle(color: Paleta.destaque)),
          ],
        ),
      );
}
