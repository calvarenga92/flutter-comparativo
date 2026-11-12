import 'package:flutter_comparativo/data/models.dart';
import 'package:flutter_comparativo/data/rn_vs_flutter.dart';
import 'package:flutter_comparativo/data/web_vs_flutter.dart';
import 'package:flutter_comparativo/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _passar(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  test('ids dos aspectos são únicos em cada comparação', () {
    for (final Comparacao c in [webVsFlutter, rnVsFlutter]) {
      final ids = c.aspectos.map((a) => a.id).toList();
      expect(ids.toSet().length, ids.length, reason: c.id);
    }
  });

  for (final tamanho in const [Size(1440, 2400), Size(390, 2400)]) {
    testWidgets('navega até o detalhe de um aspecto (${tamanho.width.toInt()}px)', (tester) async {
      tester.view.physicalSize = tamanho;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final semantica = tester.ensureSemantics();

      await tester.pumpWidget(const ComparativoApp());
      await _passar(tester);

      // Card "Web × Flutter" da seção de comparações na página inicial.
      final cartao = find.bySemanticsLabel(RegExp('^Web × Flutter')).last;
      await tester.ensureVisible(cartao);
      await tester.tap(cartao);
      await _passar(tester);

      final aspecto = find.text('Como a tela é desenhada');
      await tester.ensureVisible(aspecto);
      await tester.tap(aspecto);
      await _passar(tester);
      expect(find.text('VEREDITO'), findsOneWidget);

      // Vai para o próximo aspecto.
      final proximo = find.bySemanticsLabel(RegExp('^Próximo: Linguagem'));
      await tester.ensureVisible(proximo);
      await tester.tap(proximo);
      await _passar(tester);
      expect(find.text('Linguagem e compilação'), findsOneWidget);

      expect(tester.takeException(), isNull);
      semantica.dispose();
    });
  }
}
