import 'package:material_ui/material_ui.dart';

import 'data/rn_vs_flutter.dart';
import 'data/web_vs_flutter.dart';
import 'screens/comparacao_tela.dart';
import 'screens/escolher_tela.dart';
import 'screens/inicio_tela.dart';
import 'screens/tabela_tela.dart';
import 'theme/estilo.dart';
import 'widgets/comuns.dart';

void main() => runApp(const ComparativoApp());

class ComparativoApp extends StatelessWidget {
  const ComparativoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'comparativo. Web, React Native ou Flutter? | Claudio Alvarenga',
      debugShowCheckedModeBanner: false,
      theme: temaAgencia(),
      home: const Estrutura(),
    );
  }
}

const _paginas = ['Início', 'Web × Flutter', 'RN × Flutter', 'Tabela', 'Qual escolher?'];

/// Casca do app: barra de navegação no topo e a página atual abaixo.
class Estrutura extends StatefulWidget {
  const Estrutura({super.key});

  @override
  State<Estrutura> createState() => _EstruturaState();
}

class _EstruturaState extends State<Estrutura> {
  int _indice = 0;

  void _ir(int i) => setState(() => _indice = i);

  Widget _pagina() => switch (_indice) {
        0 => const InicioTela(),
        1 => const ComparacaoTela(comparacao: webVsFlutter, numero: '01'),
        2 => const ComparacaoTela(comparacao: rnVsFlutter, numero: '02'),
        3 => const TabelaTela(),
        _ => const EscolherTela(),
      };

  @override
  Widget build(BuildContext context) {
    final largo = MediaQuery.sizeOf(context).width >= 980;

    return Navegacao(
      ir: _ir,
      atual: _indice,
      child: Scaffold(
        endDrawer: largo ? null : _MenuMobile(atual: _indice, aoIr: _ir),
        body: Column(
          children: [
            _BarraTopo(largo: largo, atual: _indice, aoIr: _ir),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, 0.02), end: Offset.zero).animate(anim),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(key: ValueKey(_indice), child: _pagina()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraTopo extends StatelessWidget {
  const _BarraTopo({required this.largo, required this.atual, required this.aoIr});

  final bool largo;
  final int atual;
  final ValueChanged<int> aoIr;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: margemLateral(w)),
      decoration: const BoxDecoration(
        color: Paleta.fundo,
        border: Border(bottom: BorderSide(color: Paleta.borda)),
      ),
      child: Row(
        children: [
          Hover(onTap: () => aoIr(0), builder: (_, _) => const Marca()),
          const Spacer(),
          if (largo) ...[
            for (var i = 1; i < 4; i++)
              _LinkTopo(rotulo: _paginas[i], ativo: atual == i, onTap: () => aoIr(i)),
            const SizedBox(width: 20),
            BotaoPill(rotulo: 'Qual escolher?', onTap: () => aoIr(4)),
          ] else
            Builder(
              builder: (ctx) => IconButton(
                tooltip: 'Menu',
                icon: const Icon(Icons.menu, color: Paleta.texto),
                onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              ),
            ),
        ],
      ),
    );
  }
}

class _LinkTopo extends StatelessWidget {
  const _LinkTopo({required this.rotulo, required this.ativo, required this.onTap});

  final String rotulo;
  final bool ativo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: ativo,
      child: Hover(
        onTap: onTap,
        builder: (context, emCima) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: Fontes.corpo,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ativo || emCima ? Paleta.texto : Paleta.textoSuave,
                ),
                child: Text(rotulo),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                height: 2,
                width: ativo ? 24 : (emCima ? 12 : 0),
                color: Paleta.destaque,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuMobile extends StatelessWidget {
  const _MenuMobile({required this.atual, required this.aoIr});

  final int atual;
  final ValueChanged<int> aoIr;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Paleta.fundo,
      width: double.infinity,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Marca(),
                const Spacer(),
                IconButton(
                  tooltip: 'Fechar',
                  icon: const Icon(Icons.close, color: Paleta.texto),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ]),
              const SizedBox(height: 48),
              for (var i = 0; i < _paginas.length; i++)
                Hover(
                  onTap: () {
                    Navigator.of(context).pop();
                    aoIr(i);
                  },
                  builder: (_, _) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 14),
                          child: Text('0$i', style: Tipo.rotulo),
                        ),
                        Expanded(
                          child: Text(
                            _paginas[i],
                            style: TextStyle(
                              fontFamily: Fontes.titulo,
                              fontWeight: FontWeight.w700,
                              fontSize: 38,
                              letterSpacing: -1,
                              color: atual == i ? Paleta.destaque : Paleta.texto,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
