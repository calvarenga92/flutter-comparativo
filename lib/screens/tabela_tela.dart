import 'package:material_ui/material_ui.dart';

import '../theme/estilo.dart';
import '../widgets/comuns.dart';

class _Linha {
  const _Linha(this.criterio, this.web, this.rn, this.flutter);
  final String criterio;
  final String web;
  final String rn;
  final String flutter;
}

const _linhas = [
  _Linha('Linguagem', 'HTML, CSS, JavaScript/TypeScript', 'JavaScript/TypeScript + React', 'Dart'),
  _Linha('Quem mantém', 'W3C/WHATWG e navegadores', 'Meta e comunidade', 'Google e comunidade'),
  _Linha('Quem desenha a tela', 'Motor do navegador', 'Componentes nativos do sistema', 'Motor próprio (Impeller)'),
  _Linha('Execução', 'JIT no motor JS do navegador', 'Bytecode no Hermes', 'Código de máquina (AOT)'),
  _Linha('Layout', 'CSS: fluxo, Flexbox, Grid', 'Flexbox (Yoga)', 'Widgets e restrições (Row, Column, Stack)'),
  _Linha('Estilo', 'CSS com cascata', 'StyleSheet (objetos JS)', 'Propriedades de widget + ThemeData'),
  _Linha('Visual', 'Igual em todo lugar (com variações por navegador)', 'Nativo de cada sistema', 'Idêntico em todas as plataformas'),
  _Linha('Recarga em dev', 'HMR (Vite)', 'Fast Refresh', 'Stateful Hot Reload'),
  _Linha('Distribuição', 'URL', 'Lojas', 'Lojas (e web)'),
  _Linha('Atualização', 'Imediata', 'Loja ou OTA (EAS Update)', 'Loja (ou Shorebird)'),
  _Linha('Acesso ao hardware', 'Limitado pelo navegador', 'Total', 'Total'),
  _Linha('Offline', 'Com Service Worker', 'Nativo', 'Nativo'),
  _Linha('SEO', 'Excelente', 'Possível com react-native-web', 'Fraco (canvas)'),
  _Linha('Plataformas', 'Qualquer navegador', 'Android, iOS (+ Web, Windows, macOS)', 'Android, iOS, Web, Windows, macOS, Linux'),
  _Linha('Pacotes', 'npm', 'npm + Expo', 'pub.dev'),
  _Linha('Testes', 'Vitest/Jest, Playwright', 'Jest, RNTL, Detox, Maestro', 'flutter_test, golden, integration_test'),
];

/// Quantidade de critérios na tabela (usada nos números da página inicial).
int get totalCriterios => _linhas.length;

const _colunas = [('Web', Paleta.web), ('React Native', Paleta.rn), ('Flutter', Paleta.flutter)];

class TabelaTela extends StatelessWidget {
  const TabelaTela({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final largo = w >= 900;

    return SelectionArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Conteudo(
              child: Padding(
                padding: EdgeInsets.only(top: w < 600 ? 56 : 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('Tabela resumo'),
                    const SizedBox(height: 28),
                    Text('Lado a lado.', style: Tipo.display(w)),
                    const SizedBox(height: 32),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Text(
                        'As três tecnologias em $totalCriterios critérios. Para o detalhe '
                        'de cada ponto, com código e veredito, veja as comparações.',
                        style: Tipo.lead,
                      ),
                    ),
                    const SizedBox(height: 72),
                    if (largo) ...[
                      // Cabeçalho fixo da tabela
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Paleta.texto)),
                        ),
                        child: Row(children: [
                          Expanded(flex: 3, child: Text('CRITÉRIO', style: Tipo.rotulo)),
                          for (final (nome, cor) in _colunas)
                            Expanded(
                              flex: 4,
                              child: Text(nome,
                                  style: TextStyle(
                                    fontFamily: Fontes.titulo,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28,
                                    letterSpacing: -0.8,
                                    color: cor,
                                  )),
                            ),
                        ]),
                      ),
                      for (final l in _linhas) _LinhaLarga(linha: l),
                    ] else
                      for (final l in _linhas) _BlocoEstreito(linha: l),
                  ],
                ),
              ),
            ),
            const Rodape(),
          ],
        ),
      ),
    );
  }
}

class _LinhaLarga extends StatelessWidget {
  const _LinhaLarga({required this.linha});

  final _Linha linha;

  @override
  Widget build(BuildContext context) {
    return Hover(
      builder: (context, emCima) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: emCima ? Paleta.superficie : Colors.transparent,
          border: const Border(bottom: BorderSide(color: Paleta.borda)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 16, top: 2),
                child: Text(linha.criterio.toUpperCase(),
                    style: Tipo.rotulo.copyWith(color: emCima ? Paleta.destaque : Paleta.textoSuave)),
              ),
            ),
            for (final t in [linha.web, linha.rn, linha.flutter])
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Text(t, style: const TextStyle(fontSize: 16, height: 1.5)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BlocoEstreito extends StatelessWidget {
  const _BlocoEstreito({required this.linha});

  final _Linha linha;

  @override
  Widget build(BuildContext context) {
    final valores = [linha.web, linha.rn, linha.flutter];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Paleta.borda))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(linha.criterio,
              style: const TextStyle(
                fontFamily: Fontes.titulo,
                fontWeight: FontWeight.w700,
                fontSize: 24,
                letterSpacing: -0.5,
              )),
          const SizedBox(height: 16),
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  width: 110,
                  child: Text(_colunas[i].$1.toUpperCase(),
                      style: Tipo.rotulo.copyWith(color: _colunas[i].$2, fontSize: 11)),
                ),
                Expanded(child: Text(valores[i])),
              ]),
            ),
        ],
      ),
    );
  }
}
