import 'package:material_ui/material_ui.dart';

/// Paleta do app: fundo quase preto, texto off-white e um destaque lima.
abstract final class Paleta {
  static const fundo = Color(0xFF0A0A0B);
  static const superficie = Color(0xFF121215);
  static const superficie2 = Color(0xFF1A1A1F);
  static const borda = Color(0xFF26262D);
  static const texto = Color(0xFFF2F0EB);
  static const textoSuave = Color(0xFF9B99A3);
  static const destaque = Color(0xFFC6F432);
  static const sobreDestaque = Color(0xFF0A0A0B);

  static const web = Color(0xFFFF6A3D);
  static const rn = Color(0xFF58C4DC);
  static const flutter = Color(0xFF5B9BFF);
}

abstract final class Fontes {
  static const titulo = 'SpaceGrotesk';
  static const corpo = 'Inter';
  static const mono = 'JetBrainsMono';
}

/// Estilos tipográficos usados fora do TextTheme (títulos gigantes, rótulos).
abstract final class Tipo {
  /// Título de destaque cujo tamanho acompanha a largura da tela.
  static TextStyle display(double largura, {double min = 44, double max = 120}) => TextStyle(
        fontFamily: Fontes.titulo,
        fontWeight: FontWeight.w700,
        fontSize: (largura * 0.085).clamp(min, max),
        height: 0.98,
        letterSpacing: -2,
        color: Paleta.texto,
      );

  static TextStyle tituloSecao(double largura) => TextStyle(
        fontFamily: Fontes.titulo,
        fontWeight: FontWeight.w700,
        fontSize: (largura * 0.045).clamp(32, 64),
        height: 1.02,
        letterSpacing: -1.2,
        color: Paleta.texto,
      );

  static const rotulo = TextStyle(
    fontFamily: Fontes.mono,
    fontSize: 12,
    letterSpacing: 1.6,
    color: Paleta.textoSuave,
  );

  static const lead = TextStyle(
    fontFamily: Fontes.corpo,
    fontSize: 19,
    height: 1.55,
    color: Paleta.textoSuave,
  );
}

ThemeData temaAgencia() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: Fontes.corpo,
    scaffoldBackgroundColor: Paleta.fundo,
    colorScheme: const ColorScheme.dark(
      primary: Paleta.destaque,
      onPrimary: Paleta.sobreDestaque,
      secondary: Paleta.flutter,
      surface: Paleta.superficie,
      onSurface: Paleta.texto,
      onSurfaceVariant: Paleta.textoSuave,
      outline: Paleta.borda,
      outlineVariant: Paleta.borda,
    ),
    splashFactory: InkSparkle.splashFactory,
    dividerTheme: const DividerThemeData(color: Paleta.borda, thickness: 1, space: 1),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Paleta.destaque,
      contentTextStyle: TextStyle(color: Paleta.sobreDestaque, fontWeight: FontWeight.w600),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Paleta.destaque.withValues(alpha: 0.35),
      cursorColor: Paleta.destaque,
    ),
  );

  final t = base.textTheme.apply(bodyColor: Paleta.texto, displayColor: Paleta.texto);
  TextStyle? titulo(TextStyle? s) =>
      s?.copyWith(fontFamily: Fontes.titulo, fontWeight: FontWeight.w700, letterSpacing: -0.5);

  return base.copyWith(
    textTheme: t.copyWith(
      displayLarge: titulo(t.displayLarge),
      displayMedium: titulo(t.displayMedium),
      displaySmall: titulo(t.displaySmall),
      headlineLarge: titulo(t.headlineLarge),
      headlineMedium: titulo(t.headlineMedium),
      headlineSmall: titulo(t.headlineSmall),
      titleLarge: titulo(t.titleLarge),
      titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: t.bodyLarge?.copyWith(height: 1.6, fontSize: 17),
      bodyMedium: t.bodyMedium?.copyWith(height: 1.55, fontSize: 15),
    ),
  );
}
