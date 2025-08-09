import 'package:flutter/material.dart';

/// =======================
/// HARD-CODED DANGER PALETTE
/// =======================
class _DangerPalette {
  final Color filledBg;
  final Color filledFg;
  final Color tonalBg;
  final Color tonalFg;
  final Color textFg;
  final Color overlayOnFilled;
  final Color overlayOnTonal;
  final Color overlayOnText;

  const _DangerPalette({
    required this.filledBg,
    required this.filledFg,
    required this.tonalBg,
    required this.tonalFg,
    required this.textFg,
    required this.overlayOnFilled,
    required this.overlayOnTonal,
    required this.overlayOnText,
  });

  /// Light mode palette (hardcoded)
  factory _DangerPalette.light() {
    // Base tones
    const Color baseError = Color(0xFFD32F2F);
    const Color surfaceLight = Color(0xFFF5F7F9);

    // 12% alpha = 31 (0x1F), 8% alpha = 20 (0x14)
    final Color tone12 = baseError.withAlpha(0x1F);
    const Color overlayFilled = Color(0x1FFFFFFF); // white 12%
    const Color overlaySubtle = Color(0x14D32F2F); // error 8%

    // Tonal background = error 12% over light surface
    final Color tonalBg = Color.alphaBlend(tone12, surfaceLight);

    return _DangerPalette(
      filledBg: baseError,
      filledFg: Colors.white,
      tonalBg: tonalBg,
      tonalFg: baseError,
      textFg: baseError,
      overlayOnFilled: overlayFilled,
      overlayOnTonal: overlaySubtle,
      overlayOnText: overlaySubtle,
    );
  }

  /// Dark mode palette (hardcoded)
  factory _DangerPalette.dark() {
    const Color baseError = Color(0xFFEF5350);
    const Color surfaceDark = Color(0xFF1C1B1A);

    final Color tone12 = baseError.withAlpha(0x1F); // 12%
    const Color overlayFilled = Color(0x1FFFFFFF); // white 12%
    const Color overlaySubtle = Color(0x14FFFFFF); // white 8%

    final Color tonalBg = Color.alphaBlend(tone12, surfaceDark);

    return _DangerPalette(
      filledBg: baseError,
      filledFg: Colors.white,
      tonalBg: tonalBg,
      tonalFg: Color(0xFFEF9A9A),
      textFg: Color(0xFFEF9A9A),
      overlayOnFilled: overlayFilled,
      overlayOnTonal: overlaySubtle,
      overlayOnText: overlaySubtle,
    );
  }
}

_DangerPalette _paletteFor(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  return brightness == Brightness.dark ? _DangerPalette.dark() : _DangerPalette.light();
}

/// =======================
/// PUBLIC WIDGET API
/// =======================
enum DangerButtonVariant { filled, tonal, text }

enum DangerButtonSize { small, medium, large }

class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final DangerButtonVariant variant;
  final DangerButtonSize size;
  final bool expand; // full width jika true

  const DangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = DangerButtonVariant.filled,
    this.size = DangerButtonSize.medium,
    this.expand = false,
  });

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case DangerButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case DangerButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case DangerButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    }
  }

  double get _iconSize {
    switch (size) {
      case DangerButtonSize.small:
        return 18;
      case DangerButtonSize.medium:
        return 20;
      case DangerButtonSize.large:
        return 22;
    }
  }

  RoundedRectangleBorder get _shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  @override
  Widget build(BuildContext context) {
    final p = _paletteFor(context);

    final child = _ButtonContent(
      label: label,
      icon: icon,
      isLoading: isLoading,
      iconSize: _iconSize,
    );

    // Tambah textStyle ke ButtonStyle, jangan set style di Text child
    const labelStyle = MaterialStatePropertyAll<TextStyle>(TextStyle(fontWeight: FontWeight.w600));

    // Gunakan MaterialStatePropertyAll agar foreground/overlay tidak di-override
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
      DangerButtonVariant.filled => FilledButton(
        style: filledStyle,
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
      DangerButtonVariant.tonal => FilledButton.tonal(
        style: tonalStyle,
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
      DangerButtonVariant.text => TextButton(
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
    // Jangan set style di sini agar foregroundColor dari ButtonStyle yang menang
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

/// Dialog konfirmasi bawaan (menggunakan palette hardcoded sesuai mode)
Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  String title = 'Delete item?',
  String message = 'This action cannot be undone.',
  String confirmText = 'Delete',
  String cancelText = 'Cancel',
}) async {
  final p = _paletteFor(context);
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

/// Tombol delete dengan konfirmasi otomatis.
class ConfirmingDangerButton extends StatelessWidget {
  final String label;
  final Future<void> Function() onConfirmed;
  final IconData icon;
  final DangerButtonVariant variant;
  final DangerButtonSize size;
  final bool expand;
  final String dialogTitle;
  final String dialogMessage;
  final String dialogConfirmText;
  final String dialogCancelText;
  final bool isLoading;

  const ConfirmingDangerButton({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.icon = Icons.delete_outline,
    this.variant = DangerButtonVariant.filled,
    this.size = DangerButtonSize.medium,
    this.expand = false,
    this.dialogTitle = 'Delete item?',
    this.dialogMessage = 'This action cannot be undone.',
    this.dialogConfirmText = 'Delete',
    this.dialogCancelText = 'Cancel',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DangerButton(
      label: label,
      icon: icon,
      variant: variant,
      size: size,
      expand: expand,
      isLoading: isLoading,
      onPressed: isLoading
          ? null
          : () async {
              final ok = await showConfirmDeleteDialog(
                context,
                title: dialogTitle,
                message: dialogMessage,
                confirmText: dialogConfirmText,
                cancelText: dialogCancelText,
              );
              if (ok) await onConfirmed();
            },
    );
  }
}
