import 'package:material_ui/material_ui.dart';

import '../data/models.dart';
import '../data/rn_vs_flutter.dart';
import '../data/web_vs_flutter.dart';
import '../theme/estilo.dart';
import '../widgets/comuns.dart';
import 'escolher_tela.dart';
import 'tabela_tela.dart';

const _palavras = [
  'Impeller', 'DOM', 'Hermes', 'Hot Reload', 'JSI', 'Fabric', 'CanvasKit',
  'Dart', 'TypeScript', 'PWA', 'SEO', 'Widgets', 'Flexbox', 'Expo', 'pub.dev',
];

class InicioTela extends StatelessWidget {
  const InicioTela({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Hero(),
          Marquee(itens: _palavras),
          SizedBox(height: 120),
          _SecaoPipeline(),
          SizedBox(height: 140),
          _SecaoComparacoes(),
          SizedBox(height: 140),
          _SecaoFerramentas(),
          Rodape(),
        ],
      ),
    );
  }
}

// ─────────────────────────── Hero ───────────────────────────

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final nav = Navegacao.of(context);
    final display = Tipo.display(w);
    final contorno = display.copyWith(
      color: null,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = Paleta.texto,
    );

    final total = webVsFlutter.aspectos.length + rnVsFlutter.aspectos.length;
    final numeros = [
      ('$total', 'aspectos comparados'),
      ('3', 'tecnologias'),
      ('$totalCriterios', 'critérios na tabela'),
      ('$totalPerguntas', 'perguntas no teste'),
    ];

    return Stack(
      children: [
        // Brilho de fundo
        Positioned(
          right: -w * 0.15,
          top: -120,
          child: IgnorePointer(
            child: Container(
              width: w * 0.7,
              height: w * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Paleta.destaque.withValues(alpha: 0.13),
                  Paleta.flutter.withValues(alpha: 0.05),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
        ),
        Conteudo(
          vertical: 0,
          child: Padding(
            padding: EdgeInsets.only(top: w < 600 ? 56 : 104, bottom: 72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Guia comparativo · Edição 2026'),
                const SizedBox(height: 32),
                Text.rich(
                  TextSpan(style: display, children: [
                    const TextSpan(text: 'Web, React Native\n'),
                    TextSpan(text: 'ou ', style: contorno),
                    const TextSpan(text: 'Flutter'),
                    const TextSpan(text: '?', style: TextStyle(color: Paleta.destaque)),
                  ]),
                ),
                const SizedBox(height: 48),
                _DuasColunas(
                  esquerda: const Text(
                    'Comparamos, aspecto por aspecto, como cada tecnologia desenha a '
                    'tela, roda o código, acessa o aparelho e chega até o usuário, '
                    'com código lado a lado e um veredito para cada ponto.',
                    style: Tipo.lead,
                  ),
                  direita: Wrap(spacing: 12, runSpacing: 12, children: [
                    BotaoPill(rotulo: 'Explorar comparações', onTap: () => nav.ir(1)),
                    BotaoPill(rotulo: 'Fazer o teste', cheio: false, onTap: () => nav.ir(4)),
                  ]),
                ),
                const SizedBox(height: 88),
                LayoutBuilder(builder: (context, k) {
                  final colunas = k.maxWidth < 640 ? 2 : 4;
                  final largura = k.maxWidth / colunas;
                  return Wrap(children: [
                    for (final (n, rotulo) in numeros)
                      Container(
                        width: largura,
                        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 16),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Paleta.borda)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n,
                                style: const TextStyle(
                                  fontFamily: Fontes.titulo,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 52,
                                  letterSpacing: -2,
                                  height: 1,
                                )),
                            const SizedBox(height: 8),
                            Text(rotulo.toUpperCase(), style: Tipo.rotulo),
                          ],
                        ),
                      ),
                  ]);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Duas colunas lado a lado em telas largas, empilhadas no celular.
class _DuasColunas extends StatelessWidget {
  const _DuasColunas({required this.esquerda, required this.direita});

  final Widget esquerda;
  final Widget direita;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < 900) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [esquerda, const SizedBox(height: 28), direita],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: esquerda)),
        const SizedBox(width: 48),
        direita,
      ],
    );
  }
}

// ─────────────────────────── 01 Pipeline ───────────────────────────

class _SecaoPipeline extends StatelessWidget {
  const _SecaoPipeline();

  @override
  Widget build(BuildContext context) {
    return Conteudo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CabecalhoSecao(
            numero: '01',
            rotulo: 'Como funciona',
            titulo: 'Três jeitos de\ndesenhar uma tela.',
            descricao:
                'Quem transforma o seu código em pixels? A resposta explica quase '
                'todas as outras diferenças: performance, visual, SEO e acesso ao aparelho.',
          ),
          const SizedBox(height: 64),
          LayoutBuilder(builder: (context, k) {
            const cards = [
              _Pipeline(
                letra: 'A',
                titulo: 'Web',
                cor: Paleta.web,
                etapas: ['HTML + CSS + JS', 'DOM, CSSOM e layout', 'Pintura do navegador'],
                final_: 'O navegador desenha',
              ),
              _Pipeline(
                letra: 'B',
                titulo: 'React Native',
                cor: Paleta.rn,
                etapas: ['JS/TS + React', 'Hermes + JSI + Fabric', 'UIView / Android View'],
                final_: 'O sistema desenha',
              ),
              _Pipeline(
                letra: 'C',
                titulo: 'Flutter',
                cor: Paleta.flutter,
                etapas: ['Dart (widgets)', 'Compilado AOT', 'Impeller na GPU'],
                final_: 'O Flutter desenha',
              ),
            ];
            if (k.maxWidth < 860) {
              return Column(children: [
                for (final c in cards) Padding(padding: const EdgeInsets.only(bottom: 16), child: c),
              ]);
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    Expanded(child: cards[i]),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Pipeline extends StatelessWidget {
  const _Pipeline({
    required this.letra,
    required this.titulo,
    required this.cor,
    required this.etapas,
    required this.final_,
  });

  final String letra;
  final String titulo;
  final Color cor;
  final List<String> etapas;
  final String final_;

  @override
  Widget build(BuildContext context) {
    return Hover(
      builder: (context, emCima) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: emCima ? Paleta.superficie2 : Paleta.superficie,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: emCima ? cor.withValues(alpha: 0.6) : Paleta.borda),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontFamily: Fontes.titulo,
                    fontWeight: FontWeight.w700,
                    fontSize: 112,
                    height: 0.9,
                    letterSpacing: -4,
                    color: emCima ? cor : cor.withValues(alpha: 0.85),
                  ),
                  child: Text(letra),
                ),
                const Spacer(),
                Container(width: 10, height: 10, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
              ],
            ),
            const SizedBox(height: 28),
            Text(titulo,
                style: const TextStyle(
                  fontFamily: Fontes.titulo,
                  fontWeight: FontWeight.w700,
                  fontSize: 34,
                  letterSpacing: -1,
                )),
            const SizedBox(height: 28),
            for (var i = 0; i < etapas.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Paleta.borda)),
                ),
                child: Row(children: [
                  SizedBox(width: 36, child: Text('0${i + 1}', style: Tipo.rotulo)),
                  Expanded(child: Text(etapas[i])),
                ]),
              ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(Icons.brush_outlined, size: 18, color: cor),
                const SizedBox(width: 10),
                Expanded(child: Text(final_, style: TextStyle(color: cor, fontWeight: FontWeight.w600))),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── 02 Comparações ───────────────────────────

class _SecaoComparacoes extends StatelessWidget {
  const _SecaoComparacoes();

  @override
  Widget build(BuildContext context) {
    final nav = Navegacao.of(context);
    return Conteudo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CabecalhoSecao(
            numero: '02',
            rotulo: 'Comparações',
            titulo: 'Frente a frente.',
            descricao:
                'Cada comparação traz o resumo, um placar, busca por tema e uma '
                'página de detalhe para cada aspecto, com código e veredito.',
          ),
          const SizedBox(height: 56),
          const Divider(),
          _LinhaComparacao(numero: '01', comparacao: webVsFlutter, onTap: () => nav.ir(1)),
          _LinhaComparacao(numero: '02', comparacao: rnVsFlutter, onTap: () => nav.ir(2)),
        ],
      ),
    );
  }
}

class _LinhaComparacao extends StatelessWidget {
  const _LinhaComparacao({required this.numero, required this.comparacao, required this.onTap});

  final String numero;
  final Comparacao comparacao;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final c = comparacao;
    final estreito = w < 760;

    return Semantics(
      button: true,
      label: c.titulo,
      child: Hover(
        onTap: onTap,
        builder: (context, emCima) {
          final seta = AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: emCima ? Paleta.destaque : Colors.transparent,
              border: Border.all(color: emCima ? Paleta.destaque : Paleta.borda),
            ),
            child: AnimatedRotation(
              turns: emCima ? 0 : -0.125,
              duration: const Duration(milliseconds: 250),
              child: Icon(Icons.arrow_forward,
                  color: emCima ? Paleta.sobreDestaque : Paleta.texto),
            ),
          );

          final textos = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TituloVersus(
                comparacao: c,
                estilo: TextStyle(
                  fontFamily: Fontes.titulo,
                  fontWeight: FontWeight.w700,
                  fontSize: (w * 0.06).clamp(36, 80),
                  letterSpacing: -2,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 12),
              Text(c.subtitulo, style: Tipo.lead.copyWith(fontSize: 16)),
              const SizedBox(height: 16),
              Text('${c.aspectos.length} ASPECTOS · ${c.categorias.length} CATEGORIAS',
                  style: Tipo.rotulo),
            ],
          );

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(vertical: 44, horizontal: emCima && !estreito ? 24 : 0),
            decoration: BoxDecoration(
              color: emCima ? Paleta.superficie : Colors.transparent,
              border: const Border(bottom: BorderSide(color: Paleta.borda)),
            ),
            child: estreito
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(numero, style: Tipo.rotulo),
                    const SizedBox(height: 12),
                    textos,
                    const SizedBox(height: 20),
                    seta,
                  ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 80, child: Text(numero, style: Tipo.rotulo)),
                      Expanded(child: textos),
                      const SizedBox(width: 24),
                      seta,
                    ],
                  ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────── 03 Ferramentas ───────────────────────────

class _SecaoFerramentas extends StatelessWidget {
  const _SecaoFerramentas();

  @override
  Widget build(BuildContext context) {
    final nav = Navegacao.of(context);
    final cards = [
      _CartaoFerramenta(
        rotulo: 'Tabela',
        titulo: 'Tudo numa\nvisão só.',
        texto: 'As três tecnologias lado a lado em $totalCriterios critérios.',
        icone: Icons.table_chart_outlined,
        destaque: false,
        onTap: () => nav.ir(3),
      ),
      _CartaoFerramenta(
        rotulo: 'Teste',
        titulo: 'Qual combina\ncom você?',
        texto: '$totalPerguntas perguntas sobre o seu projeto e o seu time, e uma recomendação no fim.',
        icone: Icons.quiz_outlined,
        destaque: true,
        onTap: () => nav.ir(4),
      ),
    ];
    return Conteudo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CabecalhoSecao(numero: '03', rotulo: 'Ferramentas', titulo: 'Para decidir.'),
          const SizedBox(height: 56),
          LayoutBuilder(builder: (context, k) {
            if (k.maxWidth < 760) {
              return Column(children: [cards[0], const SizedBox(height: 16), cards[1]]);
            }
            return IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 16),
                Expanded(child: cards[1]),
              ]),
            );
          }),
        ],
      ),
    );
  }
}

class _CartaoFerramenta extends StatelessWidget {
  const _CartaoFerramenta({
    required this.rotulo,
    required this.titulo,
    required this.texto,
    required this.icone,
    required this.destaque,
    required this.onTap,
  });

  final String rotulo;
  final String titulo;
  final String texto;
  final IconData icone;
  final bool destaque;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final frente = destaque ? Paleta.sobreDestaque : Paleta.texto;
    return Semantics(
      button: true,
      label: rotulo,
      child: Hover(
        onTap: onTap,
        builder: (context, emCima) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, emCima ? -6 : 0, 0),
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: destaque ? Paleta.destaque : (emCima ? Paleta.superficie2 : Paleta.superficie),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: destaque ? Paleta.destaque : Paleta.borda),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(rotulo.toUpperCase(), style: Tipo.rotulo.copyWith(color: frente.withValues(alpha: 0.7))),
                const Spacer(),
                Icon(icone, color: frente),
              ]),
              const SizedBox(height: 72),
              Text(titulo,
                  style: TextStyle(
                    fontFamily: Fontes.titulo,
                    fontWeight: FontWeight.w700,
                    fontSize: 44,
                    height: 1.02,
                    letterSpacing: -1.5,
                    color: frente,
                  )),
              const SizedBox(height: 20),
              Text(texto, style: TextStyle(color: frente.withValues(alpha: 0.75), fontSize: 16, height: 1.5)),
              const SizedBox(height: 28),
              Row(children: [
                Text('Abrir', style: TextStyle(color: frente, fontWeight: FontWeight.w600)),
                AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.only(left: emCima ? 14 : 8),
                  child: Icon(Icons.arrow_forward, size: 18, color: frente),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
