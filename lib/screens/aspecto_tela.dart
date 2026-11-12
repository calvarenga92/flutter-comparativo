import 'package:material_ui/material_ui.dart';

import '../data/models.dart';
import '../theme/estilo.dart';
import '../widgets/comuns.dart';

/// Rota para o detalhe de um aspecto. Rotas empilhadas ficam fora da casca do
/// app, então recriamos o [Navegacao] aqui: trocar de página fecha o detalhe antes.
Route<void> rotaAspecto({
  required BuildContext context,
  required Comparacao comparacao,
  required int indice,
}) {
  final nav = Navegacao.of(context);
  final navigator = Navigator.of(context);
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, _, _) => Navegacao(
      atual: nav.atual,
      ir: (i) {
        navigator.popUntil((r) => r.isFirst);
        nav.ir(i);
      },
      child: AspectoTela(comparacao: comparacao, indice: indice),
    ),
    transitionsBuilder: (_, anim, _, child) {
      final curva = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curva,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.03), end: Offset.zero).animate(curva),
          child: child,
        ),
      );
    },
  );
}

/// Detalhe de um aspecto: os dois lados completos, com pontos e código.
class AspectoTela extends StatelessWidget {
  const AspectoTela({super.key, required this.comparacao, required this.indice});

  final Comparacao comparacao;
  final int indice;

  String _num(int i) => (i + 1).toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final c = comparacao;
    final a = c.aspectos[indice];
    final total = c.aspectos.length;
    final w = MediaQuery.sizeOf(context).width;

    final esquerda = _Coluna(nome: c.nomeEsquerda, cor: c.corEsquerda, lado: a.esquerda);
    final direita = _Coluna(nome: c.nomeDireita, cor: c.corDireita, lado: a.direita);

    return Scaffold(
      body: Column(
        children: [
          // Barra superior
          Container(
            height: 76,
            padding: EdgeInsets.symmetric(horizontal: margemLateral(w)),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Paleta.borda)),
            ),
            child: Row(children: [
              Hover(
                onTap: () => Navigator.of(context).pop(),
                builder: (_, emCima) => Row(children: [
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 200),
                    offset: Offset(emCima ? -0.2 : 0, 0),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(w < 600 ? 'Voltar' : 'Voltar para ${c.titulo}',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ]),
              ),
              const Spacer(),
              Text('${_num(indice)} / ${total.toString().padLeft(2, '0')}', style: Tipo.rotulo),
            ]),
          ),
          Expanded(
            child: SelectionArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Conteudo(
                      child: Padding(
                        padding: EdgeInsets.only(top: w < 600 ? 48 : 88),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Eyebrow('Aspecto ${_num(indice)} · ${a.categoria}'),
                            const SizedBox(height: 28),
                            Text(a.titulo, style: Tipo.display(w, min: 40, max: 104)),
                            const SizedBox(height: 28),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 760),
                              child: Text(a.introducao, style: Tipo.lead.copyWith(fontSize: 21)),
                            ),
                            const SizedBox(height: 24),
                            SeloVantagem(aspecto: a, comparacao: c),
                            const SizedBox(height: 72),
                            LayoutBuilder(builder: (context, k) {
                              if (k.maxWidth < 860) {
                                return Column(children: [esquerda, const SizedBox(height: 16), direita]);
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: esquerda),
                                  const SizedBox(width: 16),
                                  Expanded(child: direita),
                                ],
                              );
                            }),
                            const SizedBox(height: 16),
                            _Veredito(texto: a.veredito),
                            const SizedBox(height: 96),
                            _AnteriorProximo(comparacao: c, indice: indice),
                          ],
                        ),
                      ),
                    ),
                    const Rodape(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Coluna extends StatelessWidget {
  const _Coluna({required this.nome, required this.cor, required this.lado});

  final String nome;
  final Color cor;
  final Lado lado;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Paleta.superficie,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Paleta.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Text(nome,
                style: TextStyle(
                  fontFamily: Fontes.titulo,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  letterSpacing: -0.8,
                  color: cor,
                )),
          ]),
          const SizedBox(height: 20),
          Text(lado.resumo, style: const TextStyle(fontSize: 17, height: 1.65)),
          if (lado.pontos.isNotEmpty) ...[
            const SizedBox(height: 24),
            ListaPontos(pontos: lado.pontos, cor: cor),
          ],
          if (lado.codigo != null) ...[
            const SizedBox(height: 24),
            BlocoCodigo(codigo: lado.codigo!),
          ],
        ],
      ),
    );
  }
}

class _Veredito extends StatelessWidget {
  const _Veredito({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w < 600 ? 28 : 48),
      decoration: BoxDecoration(
        color: Paleta.destaque,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('VEREDITO', style: Tipo.rotulo.copyWith(color: Paleta.sobreDestaque)),
          const SizedBox(height: 20),
          Text(
            texto,
            style: TextStyle(
              fontFamily: Fontes.titulo,
              fontWeight: FontWeight.w700,
              fontSize: (w * 0.028).clamp(24, 40),
              height: 1.2,
              letterSpacing: -0.8,
              color: Paleta.sobreDestaque,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnteriorProximo extends StatelessWidget {
  const _AnteriorProximo({required this.comparacao, required this.indice});

  final Comparacao comparacao;
  final int indice;

  @override
  Widget build(BuildContext context) {
    final aspectos = comparacao.aspectos;
    final anterior = indice > 0 ? indice - 1 : null;
    final proximo = indice < aspectos.length - 1 ? indice + 1 : null;

    void ir(int i) => Navigator.of(context).pushReplacement(
          rotaAspecto(context: context, comparacao: comparacao, indice: i),
        );

    Widget item(int? i, {required bool proximo}) {
      if (i == null) return const SizedBox.shrink();
      return Semantics(
        button: true,
        label: proximo ? 'Próximo: ${aspectos[i].titulo}' : 'Anterior: ${aspectos[i].titulo}',
        child: Hover(
          onTap: () => ir(i),
          builder: (context, emCima) => Column(
            crossAxisAlignment: proximo ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(proximo ? 'PRÓXIMO →' : '← ANTERIOR', style: Tipo.rotulo),
              const SizedBox(height: 12),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                textAlign: proximo ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                  fontFamily: Fontes.titulo,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  height: 1.15,
                  letterSpacing: -0.8,
                  color: emCima ? Paleta.destaque : Paleta.texto,
                ),
                child: Text(aspectos[i].titulo),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 32),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Paleta.borda))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: item(anterior, proximo: false)),
          const SizedBox(width: 32),
          Expanded(child: item(proximo, proximo: true)),
        ],
      ),
    );
  }
}
