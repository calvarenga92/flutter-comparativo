import 'package:material_ui/material_ui.dart';

import 'models.dart';

const rnVsFlutter = Comparacao(
  id: 'rn-vs-flutter',
  titulo: 'React Native × Flutter',
  subtitulo: 'Os dois maiores frameworks multiplataforma para mobile',
  nomeEsquerda: 'React Native',
  nomeDireita: 'Flutter',
  corEsquerda: Color(0xFF58C4DC),
  corDireita: Color(0xFF5B9BFF),
  iconeEsquerda: Icons.blur_circular,
  iconeDireita: Icons.flutter_dash,
  resumo:
      'Os dois resolvem o mesmo problema: escrever um código e publicar no '
      'Android e no iOS. O caminho é oposto. O React Native (Meta) usa '
      'JavaScript/TypeScript e React, e a interface final é feita de componentes '
      'nativos de verdade de cada sistema. O Flutter (Google) usa Dart e desenha '
      'a própria interface com o seu motor, sem usar os componentes do sistema.',
  escolhaEsquerdaQuando: [
    'O time já é forte em React e TypeScript.',
    'Você quer compartilhar lógica, tipos e hooks com um app web em React.',
    'O app precisa seguir à risca o visual e o comportamento nativos de cada sistema.',
    'Você quer atualizações over-the-air com Expo (EAS Update).',
    'É importante contratar rápido no mercado JavaScript, que é enorme.',
  ],
  escolhaDireitaQuando: [
    'O design é próprio, com marca forte, e precisa ficar idêntico em Android e iOS.',
    'Animações complexas e interface rica são o centro do produto.',
    'Você quer mobile, desktop e web oficialmente suportados num projeto só.',
    'Prefere um kit completo e oficial, com menos dependência de bibliotecas da comunidade.',
    'O time vem de Java, Kotlin ou C# e se adapta rápido ao Dart.',
  ],
  aspectos: [
    Aspecto(
      id: 'arquitetura',
      titulo: 'Arquitetura de renderização',
      categoria: 'Arquitetura',
      icone: Icons.account_tree,
      introducao: 'A diferença de base: quem desenha o botão que aparece na tela.',
      esquerda: Lado(
        resumo:
            'O seu código React roda num motor JavaScript. O React Native '
            'transforma cada componente (<View>, <Text>) num componente nativo '
            'real: UIView no iOS, android.view.View no Android.',
        pontos: [
          'Nova Arquitetura (padrão desde a versão 0.76): Fabric (renderizador), TurboModules e JSI.',
          'O JSI permite que o JS chame C++ diretamente, sem a antiga "ponte" serializada em JSON.',
          'Layout calculado pelo Yoga, um motor de Flexbox em C++.',
          'Quem desenha os pixels é o próprio sistema operacional.',
        ],
      ),
      direita: Lado(
        resumo:
            'O Dart é compilado para código de máquina, e o motor do Flutter '
            '(Impeller) desenha tudo na GPU. O sistema operacional só fornece '
            'uma superfície em branco.',
        pontos: [
          'Não há ponte entre a linguagem e a interface: tudo acontece no mesmo runtime.',
          'Widgets, layout, gestos e animação são do próprio Flutter.',
          'Componentes nativos (mapas, WebView) entram via platform views.',
        ],
      ),
      vantagem: Vantagem.depende,
      veredito:
          'O React Native é "nativo por tradução"; o Flutter é "nativo por '
          'compilação, com interface própria". Cada modelo tem as suas vantagens.',
    ),
    Aspecto(
      id: 'linguagem',
      titulo: 'Linguagem',
      categoria: 'Arquitetura',
      icone: Icons.code,
      introducao: 'JavaScript/TypeScript contra Dart.',
      esquerda: Lado(
        resumo:
            'JavaScript ou TypeScript, as linguagens mais usadas do mundo. Em '
            'produção, o motor Hermes pré-compila o JS para bytecode, o que '
            'acelera a inicialização.',
        pontos: [
          'Hermes é o motor padrão, otimizado para mobile.',
          'Tipagem opcional com TypeScript (o padrão nos templates atuais).',
          'Toda a sintaxe moderna de JS: async/await, destructuring, módulos.',
        ],
        codigo: Codigo(
          linguagem: 'TSX',
          fonte: r'''import { useState } from 'react';
import { Pressable, Text } from 'react-native';

export function Contador() {
  const [n, setN] = useState(0);
  return (
    <Pressable onPress={() => setN(n + 1)}>
      <Text>Cliques: {n}</Text>
    </Pressable>
  );
}''',
        ),
      ),
      direita: Lado(
        resumo:
            'Dart: orientada a objetos, com tipagem estática, null safety '
            'obrigatória, records, pattern matching e sealed classes. Compilada '
            'AOT para ARM e x64.',
        pontos: [
          'JIT em desenvolvimento (hot reload) e AOT em produção.',
          'Menos popular que JS, mas fácil para quem conhece Java, Kotlin, C# ou TS.',
          'Formatador e linter oficiais (dart format, dart analyze).',
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
  Widget build(BuildContext context) => TextButton(
        onPressed: () => setState(() => n++),
        child: Text('Cliques: $n'),
      );
}''',
        ),
      ),
      vantagem: Vantagem.depende,
      veredito:
          'O React Native aproveita quem já sabe JS. O Dart pede um pouco de '
          'estudo, mas costuma agradar quem experimenta.',
    ),
    Aspecto(
      id: 'visual',
      titulo: 'Visual e fidelidade à plataforma',
      categoria: 'Interface',
      icone: Icons.phone_iphone,
      introducao: 'O app parece "de Android" ou "de iPhone"?',
      esquerda: Lado(
        resumo:
            'Como os componentes são nativos, o app herda automaticamente o '
            'visual e o comportamento do sistema: rolagem, seleção de texto, '
            'teclado, menus de contexto.',
        pontos: [
          'Quando a Apple ou o Google mudam o visual do sistema, o app acompanha.',
          'O mesmo código pode ficar diferente em cada plataforma, o que às vezes é indesejado.',
          'Platform.select() ajusta estilos por plataforma.',
        ],
      ),
      direita: Lado(
        resumo:
            'O Flutter desenha tudo, então o app fica idêntico em todos os '
            'lugares. Para parecer nativo, ele oferece os widgets Material '
            '(Android) e Cupertino (iOS) reimplementados.',
        pontos: [
          'Ótimo para apps com design próprio e marca forte.',
          'Mudanças visuais do sistema só chegam quando o Flutter as reimplementa.',
          'Widgets .adaptive (ex.: Switch.adaptive) escolhem o estilo pela plataforma.',
        ],
      ),
      vantagem: Vantagem.depende,
      veredito:
          'Quer visual 100% nativo? React Native. Quer pixel-perfect igual em '
          'tudo? Flutter.',
    ),
    Aspecto(
      id: 'componentes',
      titulo: 'Componentes prontos',
      categoria: 'Interface',
      icone: Icons.widgets,
      introducao: 'O que vem na caixa.',
      esquerda: Lado(
        resumo:
            'O núcleo é pequeno de propósito: View, Text, Image, ScrollView, '
            'FlatList, TextInput, Pressable, Modal. O resto vem da comunidade.',
        pontos: [
          'Bibliotecas de UI: React Native Paper, Tamagui, gluestack, NativeWind.',
          'Expo SDK cobre câmera, arquivos, notificações e muito mais.',
          'Você escolhe e mantém a sua coleção de dependências.',
        ],
      ),
      direita: Lado(
        resumo:
            'O SDK traz centenas de widgets oficiais: Material 3 completo, '
            'Cupertino, animações, gestos, formulários, navegação.',
        pontos: [
          'NavigationBar, Drawer, BottomSheet, DatePicker, Chip, Card, SnackBar...',
          'Animações implícitas (AnimatedContainer) e explícitas (AnimationController).',
          'Hero, PageView, CustomPainter e Slivers para rolagens complexas.',
        ],
      ),
      vantagem: Vantagem.direita,
      veredito: 'O Flutter entrega muito mais pronto, sem depender de terceiros.',
    ),
    Aspecto(
      id: 'estilo',
      titulo: 'Estilização e layout',
      categoria: 'Interface',
      icone: Icons.palette,
      introducao: 'Como se escreve a aparência.',
      esquerda: Lado(
        resumo:
            'Objetos JS parecidos com CSS (StyleSheet.create), mas sem cascata '
            'e sem seletores. O layout é Flexbox, com flexDirection "column" '
            'como padrão.',
        pontos: [
          'Propriedades em camelCase: backgroundColor, paddingHorizontal.',
          'NativeWind permite usar classes do Tailwind.',
          'Não existe CSS Grid.',
        ],
        codigo: Codigo(
          linguagem: 'TSX',
          fonte: r'''const s = StyleSheet.create({
  card: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    padding: 16,
    borderRadius: 12,
    backgroundColor: '#fff',
  },
});

<View style={s.card}>...</View>''',
        ),
      ),
      direita: Lado(
        resumo:
            'Estilo e layout são widgets ou propriedades de widgets. O que no '
            'React Native é um objeto de estilo vira composição de widgets.',
        pontos: [
          'Container, Padding, DecoratedBox, Row, Column, Expanded.',
          'ThemeData para o tema global; Theme.of(context) para ler.',
          'Árvores de widgets podem ficar profundas: extraia widgets menores.',
        ],
        codigo: Codigo(
          linguagem: 'Dart',
          fonte: r'''Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [/* ... */],
  ),
)''',
        ),
      ),
      vantagem: Vantagem.empate,
      veredito:
          'Quem vem da web acha o React Native mais familiar. O modelo do '
          'Flutter é mais verboso, porém mais explícito.',
    ),
    Aspecto(
      id: 'listas',
      titulo: 'Listas longas',
      categoria: 'Interface',
      icone: Icons.view_list,
      introducao: 'Renderizar milhares de itens sem travar.',
      esquerda: Lado(
        resumo:
            'FlatList e SectionList virtualizam os itens. Para listas muito '
            'grandes, o FlashList (Shopify) recicla as views e rende mais.',
        codigo: Codigo(
          linguagem: 'TSX',
          fonte: r'''<FlatList
  data={itens}
  keyExtractor={(i) => i.id}
  renderItem={({ item }) => <Linha item={item} />}
/>''',
        ),
      ),
      direita: Lado(
        resumo:
            'ListView.builder e os Slivers só constroem o que está visível. '
            'Como não há componente nativo para criar, o custo por item é baixo.',
        codigo: Codigo(
          linguagem: 'Dart',
          fonte: r'''ListView.builder(
  itemCount: itens.length,
  itemBuilder: (context, i) => Linha(item: itens[i]),
)''',
        ),
      ),
      vantagem: Vantagem.direita,
      veredito:
          'Os dois resolvem bem; o Flutter exige menos ajuste fino para rolagem '
          'pesada.',
    ),
    Aspecto(
      id: 'estado',
      titulo: 'Gerenciamento de estado',
      categoria: 'Interface',
      icone: Icons.sync_alt,
      introducao: 'Como os dados fluem pela interface.',
      esquerda: Lado(
        resumo:
            'É React: useState, useReducer, useContext e o ecossistema inteiro '
            'de estado do mundo web.',
        pontos: [
          'Redux Toolkit, Zustand, Jotai, MobX.',
          'TanStack Query para dados do servidor (cache, refetch, paginação).',
          'O mesmo conhecimento serve no React da web.',
        ],
      ),
      direita: Lado(
        resumo:
            'setState para estado local; InheritedWidget como base para estado '
            'compartilhado, com várias bibliotecas em cima.',
        pontos: [
          'Provider (simples), Riverpod (tipado e testável), Bloc/Cubit (eventos e streams).',
          'Streams e Futures são nativos do Dart (StreamBuilder, FutureBuilder).',
          'Sinais com o pacote signals, para quem gosta do modelo.',
        ],
      ),
      vantagem: Vantagem.empate,
      veredito: 'Os dois ecossistemas são maduros. A escolha é mais de gosto do time.',
    ),
    Aspecto(
      id: 'navegacao',
      titulo: 'Navegação',
      categoria: 'Interface',
      icone: Icons.alt_route,
      introducao: 'Telas, pilhas, abas e deep links.',
      esquerda: Lado(
        resumo:
            'Não existe navegação oficial no núcleo. O padrão é o React '
            'Navigation, ou o Expo Router, com rotas baseadas em arquivos (como no Next.js).',
        pontos: [
          'Stack, Tabs e Drawer navigators.',
          'Pilha nativa (native-stack) usa as transições do próprio sistema.',
          'Expo Router gera deep links automaticamente a partir das pastas.',
        ],
      ),
      direita: Lado(
        resumo:
            'O Navigator vem no SDK (push/pop). Para URLs e deep links, a API '
            'declarativa (Router) e o pacote go_router, mantido pelo time do Flutter.',
        pontos: [
          'Navigator.push(context, MaterialPageRoute(...)) para o caso simples.',
          'go_router: rotas por caminho, redirecionamentos, ShellRoute para abas.',
          'Transições Material e Cupertino prontas.',
        ],
      ),
      vantagem: Vantagem.empate,
      veredito: 'Expo Router e go_router chegaram a níveis parecidos de conforto.',
    ),
    Aspecto(
      id: 'performance',
      titulo: 'Performance',
      categoria: 'Recursos',
      icone: Icons.speed,
      introducao: 'Inicialização, fluidez e uso de memória.',
      esquerda: Lado(
        resumo:
            'Com a Nova Arquitetura e o Hermes, a performance é muito boa para a '
            'maioria dos apps. O gargalo clássico é sobrecarregar a thread JS.',
        pontos: [
          'Reanimated roda animações na thread de interface (worklets).',
          'Re-renderizações desnecessárias pedem memo, useMemo, useCallback.',
          'A comunicação JS ↔ nativo ficou bem mais barata com o JSI.',
        ],
      ),
      direita: Lado(
        resumo:
            'Código nativo compilado AOT e um motor feito para 60 ou 120 fps. '
            'A performance é consistente entre plataformas por construção.',
        pontos: [
          'O Impeller evita travadas de compilação de shader.',
          'Isolates para processamento pesado em paralelo.',
          'Widgets const e RepaintBoundary reduzem o trabalho por quadro.',
        ],
      ),
      vantagem: Vantagem.direita,
      veredito:
          'Diferença pequena para apps comuns; em interface muito animada, o '
          'Flutter costuma levar vantagem.',
    ),
    Aspecto(
      id: 'nativo',
      titulo: 'Integração com código nativo',
      categoria: 'Recursos',
      icone: Icons.memory,
      introducao: 'Quando o pacote pronto não existe.',
      esquerda: Lado(
        resumo:
            'Turbo Modules e Fabric Components em Kotlin, Java, Swift ou '
            'Objective-C, ou o Expo Modules API, que simplifica muito com Swift e Kotlin.',
        pontos: [
          'Codegen gera os tipos a partir de uma especificação em TypeScript.',
          'Com o Expo, "config plugins" mexem no projeto nativo sem você editar à mão.',
        ],
      ),
      direita: Lado(
        resumo:
            'Platform channels (MethodChannel, EventChannel), Pigeon para gerar '
            'código tipado e dart:ffi para chamar C diretamente.',
        pontos: [
          'Pigeon gera Dart, Kotlin e Swift a partir de uma interface em Dart.',
          'FFI é ótimo para reaproveitar bibliotecas C, C++ e Rust.',
          'Pastas android/ e ios/ ficam sempre visíveis no projeto.',
        ],
      ),
      vantagem: Vantagem.empate,
      veredito: 'Os dois acessam tudo do sistema. Expo e Pigeon facilitam bastante.',
    ),
    Aspecto(
      id: 'ecossistema',
      titulo: 'Ecossistema de pacotes',
      categoria: 'Ecossistema',
      icone: Icons.inventory_2,
      introducao: 'O que você encontra pronto.',
      esquerda: Lado(
        resumo:
            'O npm é o maior repositório de pacotes do mundo. Bibliotecas de '
            'lógica pura (date-fns, zod, axios) funcionam direto.',
        pontos: [
          'O Expo virou o caminho recomendado pela própria documentação do React Native.',
          'Nem todo pacote npm funciona: os que usam DOM ou APIs do Node não rodam.',
          'Qualidade muito variável; é preciso checar manutenção.',
        ],
      ),
      direita: Lado(
        resumo:
            'O pub.dev concentra os pacotes Dart e Flutter, com pontuação de '
            'qualidade, popularidade e plataformas suportadas.',
        pontos: [
          'O selo "Flutter Favorite" destaca pacotes recomendados.',
          'Firebase tem plugins oficiais (FlutterFire) mantidos pelo Google.',
          'Menor que o npm, mas mais focado.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito: 'O React Native ganha em volume; o Flutter, em curadoria.',
    ),
    Aspecto(
      id: 'devx',
      titulo: 'Experiência de desenvolvimento',
      categoria: 'Ferramentas',
      icone: Icons.handyman,
      introducao: 'Ciclo de edição, depuração e build.',
      esquerda: Lado(
        resumo:
            'Fast Refresh preserva o estado dos componentes. Com o Expo Go você '
            'testa no celular lendo um QR code, sem instalar Android Studio nem Xcode.',
        pontos: [
          'React Native DevTools e Chrome DevTools para depurar.',
          'EAS Build compila iOS na nuvem, até a partir do Windows.',
        ],
      ),
      direita: Lado(
        resumo:
            'Stateful hot reload em menos de um segundo. Flutter DevTools com '
            'inspetor de widgets, timeline de quadros, memória e rede.',
        pontos: [
          'flutter doctor verifica o ambiente inteiro.',
          'Build de iOS exige um Mac (ou serviços como Codemagic).',
          'Extensões oficiais para VS Code e Android Studio.',
        ],
      ),
      vantagem: Vantagem.empate,
      veredito:
          'O Expo deixa a entrada no React Native mais suave; o Flutter tem '
          'ferramentas oficiais mais coesas.',
    ),
    Aspecto(
      id: 'atualizacao',
      titulo: 'Atualizações over-the-air',
      categoria: 'Ferramentas',
      icone: Icons.cloud_sync,
      introducao: 'Corrigir um bug sem esperar a loja.',
      esquerda: Lado(
        resumo:
            'Como a lógica é um bundle JS, dá para trocá-lo remotamente. O EAS '
            'Update (Expo) faz isso de forma oficial e simples.',
        pontos: [
          'As lojas permitem atualizar código interpretado, desde que a finalidade do app não mude.',
          'Mudanças em código nativo continuam exigindo um build novo.',
        ],
      ),
      direita: Lado(
        resumo:
            'O código é compilado para nativo, então não existe OTA no SDK '
            'oficial. O Shorebird (feito por ex-integrantes do time do Flutter) oferece code push.',
        pontos: [
          'Serviço pago, com plano gratuito limitado.',
          'Na prática, a maioria dos apps Flutter publica pela loja mesmo.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito: 'O React Native com Expo tem a solução mais madura.',
    ),
    Aspecto(
      id: 'web-desktop',
      titulo: 'Web e desktop',
      categoria: 'Ecossistema',
      icone: Icons.devices,
      introducao: 'Indo além do celular.',
      esquerda: Lado(
        resumo:
            'O react-native-web (usado pelo Expo) gera HTML e DOM de verdade, '
            'então funciona melhor para SEO. Para desktop há o React Native '
            'Windows e o macOS, mantidos pela Microsoft.',
        pontos: [
          'Linux não tem suporte oficial.',
          'Muitas bibliotecas nativas não têm versão web.',
        ],
      ),
      direita: Lado(
        resumo:
            'Web, Windows, macOS e Linux são plataformas oficiais e estáveis, '
            'no mesmo projeto e com o mesmo comando (flutter build <plataforma>).',
        pontos: [
          'A web usa canvas: ótimo para apps, fraco para SEO.',
          'Ubuntu usa Flutter no seu instalador oficial.',
        ],
      ),
      vantagem: Vantagem.direita,
      veredito: 'O Flutter tem a cobertura multiplataforma mais ampla e oficial.',
    ),
    Aspecto(
      id: 'reuso-web',
      titulo: 'Reaproveitar com um site React',
      categoria: 'Ecossistema',
      icone: Icons.share,
      introducao: 'Já existe um site em React. Quanto dá para reaproveitar?',
      esquerda: Lado(
        resumo:
            'Muito. Tipos, validações, chamadas de API, hooks e estado podem ir '
            'para um pacote compartilhado num monorepo (Turborepo, Nx).',
        pontos: [
          'Os componentes visuais não são compartilháveis (div não é View), salvo com react-native-web.',
          'O mesmo time pode trabalhar na web e no mobile.',
        ],
      ),
      direita: Lado(
        resumo:
            'Quase nada de código é reaproveitado: é outra linguagem. O que se '
            'aproveita é o contrato da API (OpenAPI e geradores de cliente).',
        pontos: [
          'Uma alternativa é fazer também a web em Flutter, se SEO não importa.',
        ],
      ),
      vantagem: Vantagem.esquerda,
      veredito: 'Se a empresa já é "casa React", o React Native se encaixa melhor.',
    ),
    Aspecto(
      id: 'testes',
      titulo: 'Testes',
      categoria: 'Ferramentas',
      icone: Icons.fact_check,
      introducao: 'Do teste de unidade ao ponta a ponta.',
      esquerda: Lado(
        resumo:
            'Jest com React Native Testing Library para componentes; Detox ou '
            'Maestro para ponta a ponta no emulador.',
        pontos: [
          'O mesmo estilo de teste do React na web.',
          'Maestro descreve os fluxos em YAML e funciona com qualquer framework.',
        ],
      ),
      direita: Lado(
        resumo:
            'flutter_test (unidade e widget), golden tests e integration_test, '
            'todos oficiais e no SDK.',
        pontos: [
          'Testes de widget rodam sem emulador, em milissegundos.',
          'Patrol estende o integration_test para interagir com diálogos nativos.',
        ],
      ),
      vantagem: Vantagem.direita,
      veredito: 'O Flutter tem a história de testes mais integrada.',
    ),
    Aspecto(
      id: 'mercado',
      titulo: 'Mercado e comunidade',
      categoria: 'Ecossistema',
      icone: Icons.work,
      introducao: 'Vagas, empresas e quem mantém o projeto.',
      esquerda: Lado(
        resumo:
            'Mantido pela Meta, com contribuição forte de Microsoft, Expo, '
            'Shopify e Callstack. Grande demanda em empresas que já usam React.',
        pontos: [
          'Usado em apps de Meta, Microsoft, Shopify e Discord.',
          'Mais vagas em empresas que já têm stack JavaScript.',
        ],
      ),
      direita: Lado(
        resumo:
            'Mantido pelo Google, com crescimento forte e grande comunidade no Brasil.',
        pontos: [
          'Usado por Nubank, Google Pay, BMW, Toyota e eBay Motors.',
          'Muito popular em startups e fintechs.',
        ],
      ),
      vantagem: Vantagem.empate,
      veredito:
          'Os dois têm mercado sólido. Saber os dois é um diferencial e tanto.',
    ),
  ],
);
