import 'package:material_ui/material_ui.dart';

import 'models.dart';

const webVsFlutter = Comparacao(
  id: 'web-vs-flutter',
  titulo: 'Web × Flutter',
  subtitulo: 'Aplicação web (HTML, CSS, JS) contra um app Flutter',
  nomeEsquerda: 'Web',
  nomeDireita: 'Flutter',
  corEsquerda: Color(0xFFFF6A3D),
  corDireita: Color(0xFF5B9BFF),
  iconeEsquerda: Icons.language,
  iconeDireita: Icons.flutter_dash,
  resumo:
      'Uma aplicação web roda dentro do navegador: o HTML descreve a estrutura, '
      'o CSS descreve a aparência e o JavaScript dá o comportamento. Quem desenha '
      'a tela é o motor do navegador (Blink, WebKit, Gecko). '
      'Um app Flutter é escrito em Dart e traz o próprio motor de renderização: '
      'ele desenha cada pixel sozinho, sem usar o DOM nem os componentes nativos '
      'do sistema. O mesmo código gera apps para Android, iOS, Windows, macOS, '
      'Linux e também para a web.',
  escolhaEsquerdaQuando: [
    'O conteúdo precisa ser encontrado no Google (SEO é requisito).',
    'O acesso tem que ser instantâneo por um link, sem instalar nada.',
    'É um site de conteúdo, blog, e-commerce, landing page ou painel administrativo.',
    'O time já domina HTML, CSS, JavaScript e React, Vue ou Angular.',
    'Você quer publicar correções na hora, sem passar por revisão de loja.',
  ],
  escolhaDireitaQuando: [
    'O produto é um app instalável (presença na Play Store e na App Store).',
    'Você precisa de câmera, Bluetooth, NFC, sensores ou tarefas em segundo plano.',
    'Animações e interface precisam rodar lisas a 60 ou 120 fps no celular.',
    'Você quer um código só para mobile e desktop, com visual idêntico em todos.',
    'O app tem que funcionar bem offline, com dados locais.',
  ],
  aspectos: [
    Aspecto(
      id: 'renderizacao',
      titulo: 'Como a tela é desenhada',
      categoria: 'Arquitetura',
      icone: Icons.brush,
      introducao:
          'É a diferença mais importante e explica quase todas as outras: '
          'quem transforma o código em pixels.',
      esquerda: Lado(
        resumo:
            'O navegador lê o HTML e monta o DOM, lê o CSS e monta o CSSOM, '
            'calcula o layout, pinta e compõe as camadas. Você descreve o que quer '
            'e o motor do navegador decide como desenhar.',
        pontos: [
          'Pipeline: DOM + CSSOM → árvore de renderização → layout → pintura → composição.',
          'Mudar o DOM pode disparar novo layout (reflow) e nova pintura (repaint).',
          'O visual depende do navegador: pequenas diferenças entre Chrome, Safari e Firefox.',
          'Controles de formulário (select, date picker) usam a aparência do sistema.',
        ],
      ),
      direita: Lado(
        resumo:
            'O Flutter não usa componentes do sistema nem o DOM. O motor dele '
            '(Impeller, ou Skia em plataformas mais antigas) desenha tudo direto '
            'na GPU, como um motor de jogo.',
        pontos: [
          'Três árvores: Widget (configuração) → Element (instância) → RenderObject (layout e pintura).',
          'O resultado é igual pixel por pixel em Android, iOS, desktop e web.',
          'Botões, listas e campos são reimplementados pelo próprio Flutter (Material e Cupertino).',
          'Na web, o Flutter desenha num <canvas> com CanvasKit ou skwasm (WebAssembly).',
        ],
      ),
      vantagem: Vantagem.depende,
      veredito:
          'A web ganha em integração com o navegador e em leveza. O Flutter ganha '
          'em consistência visual e em controle total da renderização.',
    ),
    Aspecto(
      id: 'linguagem',
      titulo: 'Linguagem e compilação',
      categoria: 'Arquitetura',
      icone: Icons.code,
      introducao: 'Em que se escreve e o que vira esse código na hora de rodar.',
      esquerda: Lado(
        resumo:
            'Três linguagens com papéis separados: HTML (estrutura), CSS (estilo) '
            'e JavaScript ou TypeScript (lógica). O JS é interpretado e compilado '
            'sob demanda (JIT) pelo motor do navegador (V8, JavaScriptCore, SpiderMonkey).',
        pontos: [
          'TypeScript é transpilado para JavaScript antes de ir ao navegador.',
          'Bundlers (Vite, webpack, esbuild) juntam e minificam os arquivos.',
          'WebAssembly permite rodar C, C++, Rust e outras linguagens no navegador.',
        ],
        codigo: Codigo(
          linguagem: 'HTML + JS',
          fonte: r'''<button id="btn">Cliques: 0</button>
<script>
  let n = 0;
  const btn = document.getElementById('btn');
  btn.addEventListener('click', () => {
    n++;
    btn.textContent = `Cliques: ${n}`;
  });
</script>''',
        ),
      ),
      direita: Lado(
        resumo:
            'Uma linguagem só: Dart, para estrutura, estilo e lógica. Dart tem '
            'tipagem estática, null safety obrigatória e async/await. Em '
            'desenvolvimento roda em JIT (é isso que permite o hot reload); '
            'em produção é compilado AOT para código de máquina nativo (ARM, x64).',
        pontos: [
          'A interface também é código Dart: não existe arquivo de marcação nem de estilo separado.',
          'Para web, o Dart compila para JavaScript (dart2js) ou WebAssembly (dart2wasm).',
          'Sintaxe familiar para quem vem de Java, C#, Kotlin ou TypeScript.',
        ],
        codigo: Codigo(
          linguagem: 'Dart',
          fonte: r'''class Contador extends StatefulWidget {
  const Contador({super.key});
  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  int n = 0;
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => setState(() => n++),
        child: Text('Cliques: $n'),
      );
}''',
        ),
      ),
      vantagem: Vantagem.depende,
      veredito:
          'A web tem o ecossistema mais popular do mundo. O Flutter tem uma '
          'linguagem só, compilada para nativo, e um modelo mental unificado.',
    ),
    Aspecto(
      id: 'distribuicao',
      titulo: 'Distribuição e instalação',
      categoria: 'Entrega',
      icone: Icons.download,
      introducao: 'Como o usuário chega até a aplicação.',
      esquerda: Lado(
        resumo:
            'Basta um link. O usuário abre a URL e já está usando, sem instalar '
            'nada e sem aprovação de ninguém.',
        pontos: [
          'Funciona em qualquer aparelho com navegador.',
          'Pode virar PWA: ícone na tela inicial, tela cheia e cache offline.',
          'Sem taxa de loja e sem regra de pagamento de terceiros.',
          'O lado ruim: você não aparece nas buscas da Play Store e da App Store.',
        ],
      ),
      direita: Lado(
        resumo:
            'O app é empacotado (APK/AAB no Android, IPA no iOS, EXE/MSIX no '
            'Windows) e normalmente distribuído pelas lojas.',
        pontos: [
          'Passa pela revisão da Google e da Apple, que pode levar de horas a dias.',
          'Conta de desenvolvedor: taxa única no Google Play e anual na Apple.',
          'O app fica instalado, com ícone, notificações e acesso ao sistema.',
          'O mesmo projeto também gera uma versão web, se você quiser.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito:
          'Para alcance imediato a web é imbatível. A loja dá credibilidade e '
          'descoberta, mas cobra em processo.',
    ),
    Aspecto(
      id: 'atualizacao',
      titulo: 'Atualizações e deploy',
      categoria: 'Entrega',
      icone: Icons.system_update,
      introducao: 'O que acontece depois que você corrige um bug.',
      esquerda: Lado(
        resumo:
            'Deu deploy, todo mundo recebe na próxima vez que carregar a página. '
            'Não existe usuário "preso" numa versão antiga.',
        pontos: [
          'CI/CD simples: Vercel, Netlify, Cloudflare Pages, S3 + CDN.',
          'Rollback em segundos.',
          'Testes A/B e feature flags no servidor são triviais.',
        ],
      ),
      direita: Lado(
        resumo:
            'Cada versão nova passa pela loja, e o usuário precisa atualizar. Você '
            'convive com várias versões do app ao mesmo tempo em produção.',
        pontos: [
          'A API do backend precisa continuar compatível com versões antigas do app.',
          'Atualização forçada exige lógica própria (ex.: checar a versão mínima na abertura).',
          'Ferramentas de terceiros, como o Shorebird, permitem code push para corrigir código Dart sem a loja.',
          'Na versão web do Flutter, o deploy é tão imediato quanto o de qualquer site.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito: 'A web vence com folga em velocidade de entrega.',
    ),
    Aspecto(
      id: 'layout',
      titulo: 'Sistema de layout',
      categoria: 'Interface',
      icone: Icons.dashboard,
      introducao: 'Como os elementos são posicionados e dimensionados.',
      esquerda: Lado(
        resumo:
            'O CSS tem vários modelos de layout: fluxo normal (block e inline), '
            'Flexbox, Grid, posicionamento absoluto e fixo, além de media queries '
            'e container queries para responsividade.',
        pontos: [
          'Box model: content, padding, border, margin.',
          'O CSS Grid resolve layouts bidimensionais complexos com poucas linhas.',
          'Unidades relativas: %, em, rem, vw, vh, fr.',
          'Margens colapsando e especificidade são fontes clássicas de bug.',
        ],
        codigo: Codigo(
          linguagem: 'CSS',
          fonte: r'''.linha {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  padding: 24px;
}''',
        ),
      ),
      direita: Lado(
        resumo:
            'O layout é feito com widgets que se compõem: Row, Column, Stack, '
            'Expanded, Padding, Align. A regra de ouro é: as restrições descem, '
            'os tamanhos sobem e o pai define a posição.',
        pontos: [
          'Cada widget recebe restrições (largura e altura mínimas e máximas) do pai.',
          'Layout em uma passada só: rápido e previsível.',
          'Não existe "cascata": o layout de um widget só depende do pai e dos filhos.',
          'Responsividade com LayoutBuilder e MediaQuery.',
        ],
        codigo: Codigo(
          linguagem: 'Dart',
          fonte: r'''Padding(
  padding: const EdgeInsets.all(24),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 16,
    children: [Text('A'), Text('B'), Text('C')],
  ),
)''',
        ),
      ),
      vantagem: Vantagem.depende,
      veredito:
          'O CSS é mais expressivo (o Grid não tem equivalente direto no Flutter). '
          'O Flutter é mais previsível e mais fácil de depurar.',
    ),
    Aspecto(
      id: 'estilo',
      titulo: 'Estilização e temas',
      categoria: 'Interface',
      icone: Icons.palette,
      introducao: 'Onde ficam cores, fontes e espaçamentos.',
      esquerda: Lado(
        resumo:
            'O CSS é separado da estrutura e aplicado por seletores. Um estilo '
            'declarado num lugar pode afetar elementos em qualquer parte da página (cascata).',
        pontos: [
          'Seletores, especificidade, herança e !important.',
          'Variáveis CSS (custom properties) para temas e modo escuro.',
          'Ecossistema grande: Tailwind, Sass, CSS Modules, styled-components.',
          'Pseudo-classes prontas: :hover, :focus, :active.',
        ],
      ),
      direita: Lado(
        resumo:
            'O estilo é passado como propriedade do widget ou herdado de um '
            'ThemeData no topo da árvore. Não há seletores nem cascata global.',
        pontos: [
          'ThemeData e ColorScheme centralizam cores, tipografia e formas.',
          'Material 3 gera uma paleta inteira a partir de uma cor semente.',
          'Theme.of(context) lê o tema em qualquer ponto da árvore.',
          'Estados como hover e pressed vêm de WidgetStateProperty.',
        ],
        codigo: Codigo(
          linguagem: 'Dart',
          fonte: r'''MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    ),
  ),
)''',
        ),
      ),
      vantagem: Vantagem.depende,
      veredito:
          'O CSS é mais poderoso e flexível. O Flutter evita os efeitos colaterais '
          'da cascata, já que cada estilo fica junto do widget.',
    ),
    Aspecto(
      id: 'estado',
      titulo: 'Estado e reatividade',
      categoria: 'Interface',
      icone: Icons.sync_alt,
      introducao: 'Como a interface reage quando os dados mudam.',
      esquerda: Lado(
        resumo:
            'No JavaScript puro você altera o DOM na mão (imperativo). Por isso '
            'surgiram frameworks declarativos como React, Vue, Angular e Svelte, '
            'que recalculam a interface a partir do estado.',
        pontos: [
          'React: useState, useReducer, Context; bibliotecas como Redux, Zustand, TanStack Query.',
          'Vue e Svelte: reatividade com proxies e sinais.',
          'O estado pode viver na URL (query string), no localStorage ou nos cookies.',
        ],
      ),
      direita: Lado(
        resumo:
            'O Flutter já nasceu declarativo: a interface é uma função do estado. '
            'Ao chamar setState, o método build roda de novo e o framework '
            'atualiza só o que mudou.',
        pontos: [
          'StatelessWidget para o que não muda; StatefulWidget para estado local.',
          'InheritedWidget é a base para compartilhar estado na árvore.',
          'Gerenciadores populares: Provider, Riverpod, Bloc/Cubit, MobX, GetX.',
          'ValueNotifier e ChangeNotifier resolvem muita coisa sem biblioteca.',
        ],
      ),
      vantagem: Vantagem.empate,
      veredito:
          'Os conceitos são quase os mesmos de React. Quem conhece um aprende o '
          'outro rápido.',
    ),
    Aspecto(
      id: 'hardware',
      titulo: 'Acesso a hardware e ao sistema',
      categoria: 'Recursos',
      icone: Icons.sensors,
      introducao: 'Até onde dá para ir além da tela.',
      esquerda: Lado(
        resumo:
            'A web acessa o que o navegador libera, sempre com permissão do '
            'usuário e dentro de uma sandbox. A cobertura varia bastante entre '
            'navegadores, e o Safari no iOS é o mais restritivo.',
        pontos: [
          'Disponível: câmera e microfone (getUserMedia), geolocalização, notificações, clipboard.',
          'Parcial: Web Bluetooth, Web NFC e Web USB funcionam basicamente no Chrome e no Edge.',
          'Push no iOS só para PWA instalado na tela inicial (desde o iOS 16.4).',
          'Sem acesso a contatos, SMS ou arquivos do sistema de forma livre, e com execução em segundo plano bem limitada.',
        ],
        codigo: Codigo(
          linguagem: 'JavaScript',
          fonte: r'''navigator.geolocation.getCurrentPosition(
  (pos) => console.log(pos.coords.latitude, pos.coords.longitude),
  (erro) => console.error(erro.message),
);''',
        ),
      ),
      direita: Lado(
        resumo:
            'O Flutter acessa qualquer API nativa: pelos plugins do pub.dev ou '
            'escrevendo o código nativo você mesmo (Kotlin, Swift, C++) e '
            'chamando via platform channels.',
        pontos: [
          'Plugins prontos: câmera, Bluetooth LE, NFC, biometria, sensores, mapas, pagamentos.',
          'MethodChannel e Pigeon para conversar com Kotlin e Swift de forma tipada.',
          'dart:ffi chama bibliotecas C diretamente, sem intermediário.',
          'Tarefas em segundo plano, widgets de tela inicial e serviços nativos.',
        ],
        codigo: Codigo(
          linguagem: 'Dart',
          fonte: r'''const canal = MethodChannel('app/bateria');

Future<int> nivelDaBateria() async {
  final nivel = await canal.invokeMethod<int>('nivel');
  return nivel ?? -1;
}''',
        ),
      ),
      vantagem: Vantagem.direita,
      veredito: 'O Flutter vence: um app nativo tem acesso praticamente total ao aparelho.',
    ),
    Aspecto(
      id: 'performance',
      titulo: 'Performance',
      categoria: 'Recursos',
      icone: Icons.speed,
      introducao: 'Fluidez da interface e custo de processamento.',
      esquerda: Lado(
        resumo:
            'Uma página bem feita é muito rápida, mas tudo disputa uma única '
            'thread principal: JavaScript, layout e pintura. Muita manipulação '
            'de DOM ou JS pesado causa travadas.',
        pontos: [
          'Animar transform e opacity roda na GPU; animar width e top força reflow.',
          'Web Workers tiram cálculo pesado da thread principal.',
          'Métricas oficiais: Core Web Vitals (LCP, INP, CLS).',
          'Listas enormes pedem virtualização (react-window, TanStack Virtual).',
        ],
      ),
      direita: Lado(
        resumo:
            'O código é compilado AOT para nativo, e o motor foi feito para manter '
            '60 ou 120 fps. A interface roda numa thread e a rasterização em outra.',
        pontos: [
          'O Impeller pré-compila shaders e elimina as travadas de primeira animação.',
          'Isolates rodam código Dart em paralelo, sem memória compartilhada.',
          'ListView.builder já cria só os itens visíveis.',
          'Widgets const são reaproveitados sem reconstrução.',
        ],
      ),
      vantagem: Vantagem.direita,
      veredito:
          'Em animação e interface complexa no celular, o Flutter costuma ser '
          'mais consistente. Uma página leve, porém, abre mais rápido do que '
          'qualquer app.',
    ),
    Aspecto(
      id: 'seo',
      titulo: 'SEO e indexação',
      categoria: 'Web',
      icone: Icons.travel_explore,
      introducao: 'Ser encontrado no Google, no Bing e em redes sociais.',
      esquerda: Lado(
        resumo:
            'HTML é a língua nativa dos buscadores. Com renderização no servidor '
            '(SSR) ou geração estática (SSG), o conteúdo é indexado com facilidade.',
        pontos: [
          'Next.js, Nuxt, Astro e Remix entregam HTML pronto para o robô.',
          'Meta tags, Open Graph e dados estruturados (JSON-LD).',
          'Cada página tem a sua URL, compartilhável e indexável.',
        ],
      ),
      direita: Lado(
        resumo:
            'O Flutter Web desenha num canvas, então não há texto em HTML para o '
            'robô ler. A própria equipe do Flutter recomenda usá-lo para apps, e '
            'não para sites de conteúdo.',
        pontos: [
          'Bom para: dashboards, ferramentas internas e apps atrás de login.',
          'Ruim para: blog, landing page, loja que depende de busca orgânica.',
          'Solução comum: site institucional em HTML e o app Flutter separado.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito: 'A web vence, e não chega a ser uma disputa.',
    ),
    Aspecto(
      id: 'carregamento',
      titulo: 'Carregamento e tamanho',
      categoria: 'Web',
      icone: Icons.hourglass_bottom,
      introducao: 'O tempo até a primeira tela aparecer.',
      esquerda: Lado(
        resumo:
            'O HTML começa a aparecer antes de o resto baixar (renderização '
            'progressiva). Code splitting e lazy loading carregam só o necessário.',
        pontos: [
          'Uma página simples pode pesar poucos KB.',
          'Cache do navegador e CDN aceleram as visitas seguintes.',
        ],
      ),
      direita: Lado(
        resumo:
            'No celular, o app já está instalado e abre do armazenamento local. '
            'Na web, o Flutter precisa baixar o motor (CanvasKit ou skwasm, '
            'alguns MB) antes de mostrar qualquer coisa.',
        pontos: [
          'Um APK de release mínimo tem alguns MB por arquitetura, porque inclui o motor.',
          'Na web, a primeira visita é mais lenta; nas seguintes o cache ajuda.',
          'Deferred imports (import ... deferred as) dividem o código em partes.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito: 'A web carrega mais rápido na primeira visita.',
    ),
    Aspecto(
      id: 'offline',
      titulo: 'Funcionamento offline',
      categoria: 'Recursos',
      icone: Icons.wifi_off,
      introducao: 'O que acontece quando a internet cai.',
      esquerda: Lado(
        resumo:
            'Por padrão, nada funciona sem rede. Com Service Workers, Cache API e '
            'IndexedDB dá para montar um PWA offline, mas isso é trabalho a mais.',
        pontos: [
          'Workbox facilita as estratégias de cache.',
          'O navegador pode apagar os dados se o armazenamento ficar cheio.',
        ],
      ),
      direita: Lado(
        resumo:
            'O código já está no aparelho, então o app abre sem rede. Para os '
            'dados, há bancos locais robustos.',
        pontos: [
          'sqflite e Drift (SQLite), Hive, Isar, ObjectBox.',
          'shared_preferences para configurações simples.',
          'Arquivos no sistema com path_provider.',
        ],
      ),
      vantagem: Vantagem.direita,
      veredito: 'O Flutter, como qualquer app nativo, é offline-first por natureza.',
    ),
    Aspecto(
      id: 'acessibilidade',
      titulo: 'Acessibilidade',
      categoria: 'Interface',
      icone: Icons.accessibility_new,
      introducao: 'Leitores de tela, navegação por teclado e contraste.',
      esquerda: Lado(
        resumo:
            'HTML semântico (button, nav, label, h1...) já é acessível de graça. '
            'ARIA complementa onde a semântica não basta.',
        pontos: [
          'Leitores de tela: NVDA, JAWS, VoiceOver e TalkBack entendem HTML direto.',
          'Foco por teclado e ordem de tabulação seguem o DOM.',
          'Ferramentas de auditoria: Lighthouse e axe.',
        ],
      ),
      direita: Lado(
        resumo:
            'O Flutter monta uma árvore de semântica paralela e a traduz para a '
            'API de acessibilidade de cada plataforma (TalkBack, VoiceOver, UIA no Windows).',
        pontos: [
          'Widgets padrão já trazem semântica; o widget Semantics cobre o resto.',
          'Na web, a semântica vira um DOM invisível por cima do canvas.',
          'Testes: meetsGuideline(textContrastGuideline) no flutter_test.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito:
          'Os dois dão conta, mas na web a acessibilidade vem mais naturalmente '
          'com HTML semântico.',
    ),
    Aspecto(
      id: 'navegador',
      titulo: 'Comportamentos do navegador',
      categoria: 'Web',
      icone: Icons.open_in_browser,
      introducao: 'Aquilo que o usuário espera "de graça" numa página.',
      esquerda: Lado(
        resumo:
            'Selecionar texto, Ctrl+F, botão voltar, abrir link em nova aba, '
            'clique direito, tradução automática e extensões: tudo funciona sem '
            'você escrever uma linha.',
        pontos: [
          'Links são <a href>: dá para abrir em nova aba e copiar o endereço.',
          'Formulários com autocompletar de senha e de endereço.',
        ],
      ),
      direita: Lado(
        resumo:
            'No Flutter Web esses comportamentos precisam ser recriados ou '
            'ligados de propósito.',
        pontos: [
          'Seleção de texto só dentro de SelectionArea ou com SelectableText.',
          'Ctrl+F do navegador não encontra texto desenhado no canvas.',
          'URLs e botão voltar exigem rotas declarativas (ex.: go_router).',
          'Tradução automática do navegador não funciona no canvas.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito: 'Para quem usa um navegador, a web sempre vai parecer mais natural.',
    ),
    Aspecto(
      id: 'plataformas',
      titulo: 'Alcance de plataformas',
      categoria: 'Entrega',
      icone: Icons.devices,
      introducao: 'Onde o mesmo código consegue rodar.',
      esquerda: Lado(
        resumo:
            'Roda em qualquer coisa que tenha um navegador moderno: celular, '
            'desktop, TV, carro, geladeira.',
        pontos: [
          'Para virar app de loja: PWA, Capacitor/Cordova (WebView) ou Electron/Tauri no desktop.',
          'Apps em WebView raramente parecem nativos.',
        ],
      ),
      direita: Lado(
        resumo:
            'Um projeto gera Android, iOS, Web, Windows, macOS e Linux, todos '
            'oficialmente suportados pelo Google.',
        pontos: [
          'Também roda em sistemas embarcados (painéis de carros, quiosques).',
          'Código específico por plataforma com Platform.isAndroid ou kIsWeb.',
        ],
      ),
      vantagem: Vantagem.empate,
      veredito:
          'A web chega a mais telas. O Flutter chega com experiência nativa a '
          'mais sistemas operacionais.',
    ),
    Aspecto(
      id: 'devx',
      titulo: 'Experiência de desenvolvimento',
      categoria: 'Ferramentas',
      icone: Icons.handyman,
      introducao: 'O dia a dia de quem escreve o código.',
      esquerda: Lado(
        resumo:
            'O DevTools do navegador é maduro e poderoso. Com Vite, o HMR '
            'reflete a mudança em milissegundos.',
        pontos: [
          'Inspecionar e editar CSS ao vivo direto no navegador.',
          'Ecossistema npm gigante, para o bem e para o mal.',
          'Muitas decisões a tomar: framework, bundler, CSS, roteador, estado...',
        ],
      ),
      direita: Lado(
        resumo:
            'O stateful hot reload injeta código novo sem perder o estado da '
            'tela, em menos de um segundo. O Flutter DevTools inspeciona widgets, '
            'performance, memória e rede.',
        pontos: [
          'Kit completo e oficial: framework, widgets, testes, formatador e linter.',
          'O comando flutter doctor diagnostica o ambiente.',
          'Configurar Android Studio e Xcode na primeira vez dá trabalho.',
        ],
      ),
      vantagem: Vantagem.empate,
      veredito:
          'Os dois são excelentes. O Flutter é mais "tudo incluído"; a web, '
          'mais "monte o seu".',
    ),
    Aspecto(
      id: 'testes',
      titulo: 'Testes',
      categoria: 'Ferramentas',
      icone: Icons.fact_check,
      introducao: 'Como garantir que nada quebrou.',
      esquerda: Lado(
        resumo:
            'Você escolhe as peças: Jest ou Vitest para unidade, Testing Library '
            'para componentes, Playwright ou Cypress para ponta a ponta.',
        pontos: [
          'Testes de componente rodam em jsdom (um DOM simulado).',
          'Playwright testa em Chromium, WebKit e Firefox.',
        ],
      ),
      direita: Lado(
        resumo:
            'O pacote flutter_test vem no SDK, com três níveis: unidade, widget '
            'e integração.',
        pontos: [
          'Testes de widget rodam sem emulador e são muito rápidos.',
          'Golden tests comparam a tela com uma imagem de referência.',
          'integration_test roda no aparelho real ou no emulador.',
        ],
        codigo: Codigo(
          linguagem: 'Dart',
          fonte: r'''testWidgets('incrementa', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: Contador()));
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  expect(find.text('Cliques: 1'), findsOneWidget);
});''',
        ),
      ),
      vantagem: Vantagem.direita,
      veredito: 'O Flutter traz uma solução oficial e integrada; na web você monta a sua.',
    ),
  ],
);
