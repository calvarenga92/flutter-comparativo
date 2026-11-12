import 'package:material_ui/material_ui.dart';

import '../theme/estilo.dart';
import '../widgets/comuns.dart';

enum Tec { web, rn, flutter }

const _nomes = {Tec.web: 'Web', Tec.rn: 'React Native', Tec.flutter: 'Flutter'};
const _cores = {Tec.web: Paleta.web, Tec.rn: Paleta.rn, Tec.flutter: Paleta.flutter};
const _porques = {
  Tec.web:
      'Seu projeto depende de alcance imediato, SEO e deploy instantâneo. Uma '
      'aplicação web (com React, Vue, Next.js etc.) atende sem a burocracia das lojas.',
  Tec.rn:
      'Você quer um app nativo aproveitando o conhecimento de React e JavaScript, '
      'com visual de cada plataforma e, se quiser, atualizações OTA com Expo.',
  Tec.flutter:
      'Você quer um app nativo com interface própria, consistente e fluida, e '
      'várias plataformas (mobile, desktop, web) a partir de um código só.',
};

class _Opcao {
  const _Opcao(this.texto, this.pontos);
  final String texto;
  final Map<Tec, int> pontos;
}

class _Pergunta {
  const _Pergunta(this.texto, this.opcoes);
  final String texto;
  final List<_Opcao> opcoes;
}

const _perguntas = [
  _Pergunta('O que você está construindo?', [
    _Opcao('Site de conteúdo, blog, loja ou landing page', {Tec.web: 3}),
    _Opcao('App para baixar na loja', {Tec.rn: 2, Tec.flutter: 2}),
    _Opcao('Painel ou sistema interno com login', {Tec.web: 2, Tec.flutter: 1}),
    _Opcao('App para celular e computador', {Tec.flutter: 3}),
  ]),
  _Pergunta('O que o time já domina?', [
    _Opcao('React e TypeScript', {Tec.rn: 3, Tec.web: 1}),
    _Opcao('HTML, CSS e JS em geral', {Tec.web: 2, Tec.rn: 1}),
    _Opcao('Java, Kotlin ou C#', {Tec.flutter: 2}),
    _Opcao('Nada ainda, vamos aprender', {Tec.flutter: 1, Tec.web: 1}),
  ]),
  _Pergunta('Precisa ser encontrado no Google?', [
    _Opcao('Sim, é essencial', {Tec.web: 3}),
    _Opcao('Ajuda, mas não é o principal', {Tec.web: 1}),
    _Opcao('Não, o uso é atrás de login ou no app', {Tec.rn: 1, Tec.flutter: 1}),
  ]),
  _Pergunta('Vai usar recursos do aparelho (câmera, Bluetooth, NFC, segundo plano)?', [
    _Opcao('Sim, bastante', {Tec.rn: 2, Tec.flutter: 2}),
    _Opcao('Só o básico (foto, localização)', {Tec.web: 1, Tec.rn: 1, Tec.flutter: 1}),
    _Opcao('Não', {Tec.web: 2}),
  ]),
  _Pergunta('Como deve ser o visual?', [
    _Opcao('Idêntico em todas as plataformas, com marca forte', {Tec.flutter: 3}),
    _Opcao('Com cara nativa de Android e de iOS', {Tec.rn: 3}),
    _Opcao('Tanto faz, o importante é funcionar', {Tec.web: 1}),
  ]),
  _Pergunta('Quão importantes são animações e fluidez?', [
    _Opcao('Críticas: o produto é a experiência', {Tec.flutter: 3, Tec.rn: 1}),
    _Opcao('Importantes, mas não centrais', {Tec.rn: 1, Tec.flutter: 1}),
    _Opcao('Pouco importantes', {Tec.web: 1}),
  ]),
  _Pergunta('Com que frequência vai publicar correções?', [
    _Opcao('Várias vezes por dia, sem esperar ninguém', {Tec.web: 3, Tec.rn: 1}),
    _Opcao('Semanalmente, pela loja, tudo bem', {Tec.rn: 1, Tec.flutter: 1}),
  ]),
  _Pergunta('Já existe um site em React para reaproveitar código?', [
    _Opcao('Sim', {Tec.rn: 3}),
    _Opcao('Não', {Tec.flutter: 1}),
  ]),
];

/// Quantidade de perguntas do teste (usada nos números da página inicial).
int get totalPerguntas => _perguntas.length;

class EscolherTela extends StatefulWidget {
  const EscolherTela({super.key});

  @override
  State<EscolherTela> createState() => _EscolherTelaState();
}

class _EscolherTelaState extends State<EscolherTela> {
  final Map<int, int> _respostas = {};

  Map<Tec, int> get _placar {
    final p = {for (final t in Tec.values) t: 0};
    _respostas.forEach((q, o) {
      _perguntas[q].opcoes[o].pontos.forEach((t, v) => p[t] = p[t]! + v);
    });
    return p;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final completo = _respostas.length == _perguntas.length;
    final faltam = _perguntas.length - _respostas.length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Conteudo(
            child: Padding(
              padding: EdgeInsets.only(top: w < 600 ? 56 : 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('Teste rápido'),
                  const SizedBox(height: 28),
                  Text('Qual combina\ncom você?', style: Tipo.display(w)),
                  const SizedBox(height: 32),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: const Text(
                      'Não existe tecnologia melhor em tudo. Existe a que combina com '
                      'o seu projeto e com o seu time. Responda as perguntas abaixo.',
                      style: Tipo.lead,
                    ),
                  ),
                  const SizedBox(height: 56),
                  Row(children: [
                    Text('${_respostas.length.toString().padLeft(2, '0')} / '
                        '${_perguntas.length.toString().padLeft(2, '0')}',
                        style: Tipo.rotulo),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(end: _respostas.length / _perguntas.length),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, _) => LinearProgressIndicator(
                            value: v,
                            minHeight: 3,
                            color: Paleta.destaque,
                            backgroundColor: Paleta.borda,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  for (var q = 0; q < _perguntas.length; q++)
                    _BlocoPergunta(
                      numero: (q + 1).toString().padLeft(2, '0'),
                      pergunta: _perguntas[q],
                      escolhida: _respostas[q],
                      aoEscolher: (o) => setState(() => _respostas[q] = o),
                    ),
                  const SizedBox(height: 48),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: completo
                        ? _Resultado(
                            key: const ValueKey('resultado'),
                            placar: _placar,
                            aoRefazer: () => setState(_respostas.clear),
                          )
                        : Text(
                            'Falta${faltam > 1 ? 'm' : ''} $faltam resposta${faltam > 1 ? 's' : ''} para ver o resultado.',
                            key: const ValueKey('faltam'),
                            style: Tipo.lead,
                          ),
                  ),
                ],
              ),
            ),
          ),
          const Rodape(),
        ],
      ),
    );
  }
}

class _BlocoPergunta extends StatelessWidget {
  const _BlocoPergunta({
    required this.numero,
    required this.pergunta,
    required this.escolhida,
    required this.aoEscolher,
  });

  final String numero;
  final _Pergunta pergunta;
  final int? escolhida;
  final ValueChanged<int> aoEscolher;

  @override
  Widget build(BuildContext context) {
    final largo = MediaQuery.sizeOf(context).width >= 900;
    final conteudo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(pergunta.texto,
            style: const TextStyle(
              fontFamily: Fontes.titulo,
              fontWeight: FontWeight.w700,
              fontSize: 28,
              height: 1.15,
              letterSpacing: -0.8,
            )),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var o = 0; o < pergunta.opcoes.length; o++)
              _BotaoOpcao(
                texto: pergunta.opcoes[o].texto,
                ativa: escolhida == o,
                onTap: () => aoEscolher(o),
              ),
          ],
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Paleta.borda))),
      child: largo
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: 120,
                child: Text(numero,
                    style: TextStyle(
                      fontFamily: Fontes.titulo,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: escolhida != null ? Paleta.destaque : Paleta.textoSuave,
                    )),
              ),
              Expanded(child: conteudo),
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(numero, style: Tipo.rotulo.copyWith(color: escolhida != null ? Paleta.destaque : null)),
              const SizedBox(height: 12),
              conteudo,
            ]),
    );
  }
}

class _BotaoOpcao extends StatelessWidget {
  const _BotaoOpcao({required this.texto, required this.ativa, required this.onTap});

  final String texto;
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: ativa ? Paleta.destaque : (emCima ? Paleta.superficie2 : Colors.transparent),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: ativa ? Paleta.destaque : (emCima ? Paleta.texto : Paleta.borda)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (ativa) ...[
              const Icon(Icons.check, size: 16, color: Paleta.sobreDestaque),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                texto,
                style: TextStyle(
                  color: ativa ? Paleta.sobreDestaque : Paleta.texto,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Resultado extends StatelessWidget {
  const _Resultado({super.key, required this.placar, required this.aoRefazer});

  final Map<Tec, int> placar;
  final VoidCallback aoRefazer;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final ordem = placar.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total = placar.values.fold(0, (a, b) => a + b);
    final vencedor = ordem.first.key;
    final empatados =
        ordem.where((e) => e.value == ordem.first.value).map((e) => _nomes[e.key]!).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w < 600 ? 28 : 56),
      decoration: BoxDecoration(
        color: Paleta.superficie,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _cores[vencedor]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('Nossa recomendação', cor: _cores[vencedor]!),
          const SizedBox(height: 24),
          Text(
            '${empatados.join(' ou ')}.',
            style: Tipo.display(w, min: 44, max: 96).copyWith(color: _cores[vencedor]),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(_porques[vencedor]!, style: Tipo.lead.copyWith(color: Paleta.texto)),
          ),
          const SizedBox(height: 48),
          for (final e in ordem) ...[
            Row(children: [
              SizedBox(
                width: 140,
                child: Text(_nomes[e.key]!.toUpperCase(), style: Tipo.rotulo.copyWith(color: _cores[e.key])),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: total == 0 ? 0 : e.value / total),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: 10,
                      color: _cores[e.key],
                      backgroundColor: Paleta.borda,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 72,
                child: Text('${e.value} pts', textAlign: TextAlign.end, style: Tipo.rotulo),
              ),
            ]),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 24),
          BotaoPill(rotulo: 'Refazer o teste', cheio: false, icone: Icons.refresh, onTap: aoRefazer),
        ],
      ),
    );
  }
}
