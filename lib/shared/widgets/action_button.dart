import 'package:flutter/material.dart';

/// =======================
/// BUTTON KINDS & VARIANTS
/// =======================
enum ActionButtonKind { primary, warning, danger, custom }

enum ActionButtonVariant { filled, tonal, text }

enum ActionButtonSize { small, medium, large }

/// =======================
/// HARD-CODED PALETTE MODEL
/// =======================
class _Palette {
  final Color filledBg;
  final Color filledFg;
  final Color tonalBg;
  final Color tonalFg;
  final Color textFg;
  final Color overlayOnFilled;
  final Color overlayOnTonal;
  final Color overlayOnText;

  const _Palette({
    required this.filledBg,
    required this.filledFg,
    required this.tonalBg,
    required this.tonalFg,
    required this.textFg,
    required this.overlayOnFilled,
    required this.overlayOnTonal,
    required this.overlayOnText,
  });

  static const _surfaceLight = Color(0xFFF5F7F9);
  static const _surfaceDark = Color(0xFF1C1B1A);

  /// factory untuk Danger (merah)
  factory _Palette.danger(Brightness b) {
    if (b == Brightness.dark) {
      const base = Color(0xFFEF5350);
      final tone12 = base.withAlpha(0x1F); // 12%
      final tonal = Color.alphaBlend(tone12, _surfaceDark);
      return _Palette(
        filledBg: base,
        filledFg: Colors.white,
        tonalBg: tonal,
        tonalFg: const Color(0xFFEF9A9A),
        textFg: const Color(0xFFEF9A9A),
        overlayOnFilled: const Color(0x1FFFFFFF), // white 12%
        overlayOnTonal: const Color(0x14FFFFFF), // white 8%
        overlayOnText: const Color(0x14FFFFFF), // white 8%
      );
    } else {
      const base = Color(0xFFD32F2F);
      final tone12 = base.withAlpha(0x1F); // 12%
      final tonal = Color.alphaBlend(tone12, _surfaceLight);
      return _Palette(
        filledBg: base,
        filledFg: Colors.white,
        tonalBg: tonal,
        tonalFg: base,
        textFg: base,
        overlayOnFilled: const Color(0x1FFFFFFF), // white 12%
        overlayOnTonal: const Color(0x14D32F2F), // base 8%
        overlayOnText: const Color(0x14D32F2F), // base 8%
      );
    }
  }

  /// factory untuk Primary (hijau)
  factory _Palette.primary(Brightness b) {
    if (b == Brightness.dark) {
      const base = Color(0xFF66BB6A);
      final tone12 = base.withAlpha(0x1F);
      final tonal = Color.alphaBlend(tone12, _surfaceDark);
      return _Palette(
        filledBg: base,
        filledFg: Colors.white,
        tonalBg: tonal,
        tonalFg: const Color(0xFFA5D6A7),
        textFg: const Color(0xFFA5D6A7),
        overlayOnFilled: const Color(0x1FFFFFFF),
        overlayOnTonal: const Color(0x14FFFFFF),
        overlayOnText: const Color(0x14FFFFFF),
      );
    } else {
      const base = Color(0xFF2E7D32);
      final tone12 = base.withAlpha(0x1F);
      final tonal = Color.alphaBlend(tone12, _surfaceLight);
      return _Palette(
        filledBg: base,
        filledFg: Colors.white,
        tonalBg: tonal,
        tonalFg: base,
        textFg: base,
        overlayOnFilled: const Color(0x1FFFFFFF),
        overlayOnTonal: const Color(0x142E7D32),
        overlayOnText: const Color(0x142E7D32),
      );
    }
  }

  /// factory untuk Warning (oranye)
  factory _Palette.warning(Brightness b) {
    if (b == Brightness.dark) {
      const base = Color(0xFFFFA726); // amber terang
      final tone12 = base.withAlpha(0x1F);
      final tonal = Color.alphaBlend(tone12, _surfaceDark);
      return _Palette(
        filledBg: base,
        filledFg: Colors.black, // kontras di oranye terang
        tonalBg: tonal,
        tonalFg: const Color(0xFFFFE0B2),
        textFg: const Color(0xFFFFE0B2),
        overlayOnFilled: const Color(0x14000000), // black 8%
        overlayOnTonal: const Color(0x14FFFFFF),
        overlayOnText: const Color(0x14FFFFFF),
      );
    } else {
      const base = Color(0xFFF57C00); // oranye gelap
      final tone12 = base.withAlpha(0x1F);
      final tonal = Color.alphaBlend(tone12, _surfaceLight);
      return _Palette(
        filledBg: base,
        filledFg: Colors.white, // oranye gelap -> teks putih
        tonalBg: tonal,
        tonalFg: base,
        textFg: base,
        overlayOnFilled: const Color(0x1FFFFFFF),
        overlayOnTonal: const Color(0x14F57C00),
        overlayOnText: const Color(0x14F57C00),
      );
    }
  }

  /// factory untuk Custom (base color berbeda untuk light/dark)
  factory _Palette.custom({
    required Brightness brightness,
    required Color lightBase,
    required Color darkBase,
  }) {
    final base = brightness == Brightness.dark ? darkBase : lightBase;
    final surface = brightness == Brightness.dark ? _surfaceDark : _surfaceLight;
    final tone12 = base.withAlpha(0x1F);
    final tonal = Color.alphaBlend(tone12, surface);

    // heuristik: jika base cukup gelap di light, pakai fg putih; jika terang di dark, pakai fg hitam.
    final isDarkOnLight = brightness == Brightness.light && _luminance(base) < 0.5;
    final filledFg = (brightness == Brightness.dark)
        ? (_luminance(base) > 0.7 ? Colors.black : Colors.white)
        : (isDarkOnLight ? Colors.white : Colors.black);

    // tonal/text pakai base; overlay disesuaikan
    final overlayFilled = brightness == Brightness.dark
        ? const Color(0x14FFFFFF)
        : const Color(0x1FFFFFFF);
    final overlaySubtle = brightness == Brightness.dark
        ? const Color(0x14FFFFFF)
        : Color(_with8PercentAlpha(base));

    return _Palette(
      filledBg: base,
      filledFg: filledFg,
      tonalBg: tonal,
      tonalFg: base,
      textFg: base,
      overlayOnFilled: overlayFilled,
      overlayOnTonal: overlaySubtle,
      overlayOnText: overlaySubtle,
    );
  }

  static double _luminance(Color c) => c.computeLuminance();

  static int _with8PercentAlpha(Color c) =>
      (0x14 << 24) | (c.value & 0x00FFFFFF); // set alpha 0x14, keep RGB
}

/// ambil palette berdasarkan kind & brightness
_Palette _paletteFor(
  BuildContext context, {
  required ActionButtonKind kind,
  Color? customLightBase,
  Color? customDarkBase,
}) {
  final b = Theme.of(context).brightness;
  switch (kind) {
    case ActionButtonKind.primary:
      return _Palette.primary(b);
    case ActionButtonKind.warning:
      return _Palette.warning(b);
    case ActionButtonKind.danger:
      return _Palette.danger(b);
    case ActionButtonKind.custom:
      return _Palette.custom(
        brightness: b,
        lightBase: customLightBase ?? const Color(0xFF6A1B9A), // ungu default (light)
        darkBase: customDarkBase ?? const Color(0xFFBA68C8), // ungu terang (dark)
      );
  }
}

/// =======================
/// ACTION BUTTON (UMUM)
/// =======================
class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ActionButtonKind kind;
  final ActionButtonVariant variant;
  final ActionButtonSize size;
  final bool expand;

  /// untuk kind: custom
  final Color? customLightBase;
  final Color? customDarkBase;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.kind = ActionButtonKind.primary,
    this.variant = ActionButtonVariant.filled,
    this.size = ActionButtonSize.medium,
    this.expand = false,
    this.customLightBase,
    this.customDarkBase,
  });

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case ActionButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ActionButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ActionButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    }
  }

  double get _iconSize {
    switch (size) {
      case ActionButtonSize.small:
        return 18;
      case ActionButtonSize.medium:
        return 20;
      case ActionButtonSize.large:
        return 22;
    }
  }

  RoundedRectangleBorder get _shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  @override
  Widget build(BuildContext context) {
    final p = _paletteFor(
      context,
      kind: kind,
      customLightBase: customLightBase,
      customDarkBase: customDarkBase,
    );

    final child = _ButtonContent(
      label: label,
      icon: icon,
      isLoading: isLoading,
      iconSize: _iconSize,
    );

    const labelStyle = MaterialStatePropertyAll<TextStyle>(TextStyle(fontWeight: FontWeight.w600));

    final ButtonStyle filledStyle =
        FilledButton.styleFrom(
          padding: _padding,
          backgroundColor: p.filledBg,
          shape: _shape,
        ).copyWith(
          foregroundColor: MaterialStatePropertyAll<Color>(p.filledFg),
          overlayColor: MaterialStatePropertyAll<Color>(p.overlayOnFilled),
          textStyle: labelStyle,
        );

    final ButtonStyle tonalStyle =
        FilledButton.styleFrom(
          padding: _padding,
          backgroundColor: p.tonalBg,
          shape: _shape,
        ).copyWith(
          foregroundColor: MaterialStatePropertyAll<Color>(p.tonalFg),
          overlayColor: MaterialStatePropertyAll<Color>(p.overlayOnTonal),
          textStyle: labelStyle,
        );

    final ButtonStyle textStyle = TextButton.styleFrom(padding: _padding, shape: _shape).copyWith(
      foregroundColor: MaterialStatePropertyAll<Color>(p.textFg),
      overlayColor: MaterialStatePropertyAll<Color>(p.overlayOnText),
      textStyle: labelStyle,
    );

    final Widget btn = switch (variant) {
      ActionButtonVariant.filled => FilledButton(
        style: filledStyle,
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
      ActionButtonVariant.tonal => FilledButton.tonal(
        style: tonalStyle,
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
      ActionButtonVariant.text => TextButton(
        style: textStyle,
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    };

    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final double iconSize;

  const _ButtonContent({
    required this.label,
    this.icon,
    required this.isLoading,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          text,
        ],
      );
    }

    if (icon == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize),
        const SizedBox(width: 8),
        text,
      ],
    );
  }
}

/// =======================
/// CONFIRMING ACTION BUTTON
/// (munculkan dialog konfirmasi sebelum eksekusi)
/// =======================
class ConfirmingActionButton extends StatelessWidget {
  final String label;
  final Future<void> Function() onConfirmed;
  final ActionButtonKind kind;
  final ActionButtonVariant variant;
  final ActionButtonSize size;
  final bool expand;
  final bool isLoading;
  final IconData icon;

  // dialog
  final String dialogTitle;
  final String dialogMessage;
  final String dialogConfirmText;
  final String dialogCancelText;

  // custom base (jika kind=custom)
  final Color? customLightBase;
  final Color? customDarkBase;

  const ConfirmingActionButton({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.kind = ActionButtonKind.danger,
    this.variant = ActionButtonVariant.filled,
    this.size = ActionButtonSize.medium,
    this.expand = false,
    this.isLoading = false,
    this.icon = Icons.delete_outline,
    this.dialogTitle = 'Are you sure?',
    this.dialogMessage = 'This action cannot be undone.',
    this.dialogConfirmText = 'Confirm',
    this.dialogCancelText = 'Cancel',
    this.customLightBase,
    this.customDarkBase,
  });

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      label: label,
      icon: icon,
      kind: kind,
      variant: variant,
      size: size,
      expand: expand,
      isLoading: isLoading,
      customLightBase: customLightBase,
      customDarkBase: customDarkBase,
      onPressed: isLoading
          ? null
          : () async {
              final ok = await _showConfirmDialog(
                context,
                kind: kind,
                title: dialogTitle,
                message: dialogMessage,
                confirmText: dialogConfirmText,
                cancelText: dialogCancelText,
                customLightBase: customLightBase,
                customDarkBase: customDarkBase,
              );
              if (ok) await onConfirmed();
            },
    );
  }
}

Future<bool> _showConfirmDialog(
  BuildContext context, {
  required ActionButtonKind kind,
  required String title,
  required String message,
  required String confirmText,
  required String cancelText,
  Color? customLightBase,
  Color? customDarkBase,
}) async {
  final p = _paletteFor(
    context,
    kind: kind,
    customLightBase: customLightBase,
    customDarkBase: customDarkBase,
  );

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(cancelText)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: p.filledBg).copyWith(
            foregroundColor: MaterialStatePropertyAll<Color>(p.filledFg),
            textStyle: const MaterialStatePropertyAll<TextStyle>(
              TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return result ?? false;
}
