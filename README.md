# comparativo. Web, React Native ou Flutter?

**[flutter-comparativo.vercel.app](https://flutter-comparativo.vercel.app)**

Guia interativo, feito em Flutter, que compara aspecto por aspecto uma
**aplicação web com Flutter** e o **React Native com Flutter**: como cada um
desenha a tela, roda o código, acessa o aparelho e chega ao usuário, com
código lado a lado e um veredito para cada ponto.

O próprio site é a demonstração: ele roda na web, mas cada pixel é desenhado
pelo motor do Flutter, não pelo DOM.

`Flutter 3.50` · `Dart 3.14` · `Material 3` · `Vercel`

## O que tem

- **Início**: o pipeline de renderização da Web, do React Native e do Flutter.
- **Web × Flutter**: 16 aspectos (renderização, linguagem, distribuição, layout,
  estilo, estado, hardware, performance, SEO, offline, acessibilidade...).
- **React Native × Flutter**: 17 aspectos (arquitetura Fabric/JSI contra
  Impeller, visual nativo, componentes, listas, navegação, OTA, ecossistema...).
- **Tabela**: as três tecnologias lado a lado em 16 critérios.
- **Qual escolher?**: teste de 8 perguntas que recomenda uma tecnologia.

Cada aspecto tem página própria com os dois lados, pontos-chave, exemplos de
código e veredito, além de navegação para o anterior e o próximo.

## Rodando

O SDK do Flutter fica em `C:\tools\flutter`. Como ele não está no PATH, o
`rodar.sh` faz a chamada:

```bash
./rodar.sh            # abre no Chrome com hot reload
./rodar.sh test       # testes
./rodar.sh analyze    # análise estática
./rodar.sh build      # build de produção em build/web
```

Com o Flutter no PATH, basta `flutter run -d chrome`.

## Estrutura

```
lib/
  main.dart                 # app, barra de navegação e menu mobile
  theme/estilo.dart         # paleta, tipografia e tema
  data/
    models.dart             # Comparacao, Aspecto, Lado, Codigo, Vantagem
    web_vs_flutter.dart     # conteúdo Web × Flutter
    rn_vs_flutter.dart      # conteúdo React Native × Flutter
  screens/
    inicio_tela.dart
    comparacao_tela.dart    # lista com busca, filtro e placar
    aspecto_tela.dart       # detalhe com anterior e próximo
    tabela_tela.dart
    escolher_tela.dart      # teste
  widgets/comuns.dart       # componentes compartilhados
assets/fonts/               # Space Grotesk, Inter e JetBrains Mono (SIL OFL)
test/app_test.dart
```

O conteúdo fica separado do layout: para incluir um aspecto, basta adicionar
um `Aspecto` à lista do arquivo de dados correspondente.

A partir do Flutter 3.47, o Material saiu do SDK e virou o pacote
[`material_ui`](https://pub.dev/packages/material_ui). Por isso os imports usam
`package:material_ui/material_ui.dart`.

## Deploy

Push na `main` publica em produção pela integração com a Vercel. O
`vercel.json` baixa o Flutter 3.50.0 no build, roda `flutter build web` e
serve `build/web`. Não há variável de ambiente para configurar.

---

Desenvolvido por Claudio Alvarenga.
[Portfólio](https://claudio-alvarenga.vercel.app) ·
[GitHub](https://github.com/calvarenga92) ·
[LinkedIn](https://linkedin.com/in/cralvarenga)
