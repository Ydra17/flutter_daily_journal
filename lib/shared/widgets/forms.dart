// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLines; // Default to single line, can be adjusted if needed
  const CustomTextField({super.key, required this.controller, required this.label, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(51, 158, 158, 158), // Colors.grey.withOpacity(0.2)
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1, // Default to single line if not specified
        validator: (value) => value == null || value.isEmpty ? '$label Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class CustomTextField2 extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLines; // default 1
  final String? hintText; // opsional

  const CustomTextField2({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines,
    this.hintText,
  });

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  final FocusNode _focusNode = FocusNode();
  bool _hover = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bool hasFocus = _focusNode.hasFocus;
    final borderColor = hasFocus ? cs.primary : cs.outlineVariant; // halus, adaptif light/dark

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        // Gunakan Material + shape border agar dapat elevation overlay yang pas di dark mode
        decoration: ShapeDecoration(
          color: theme.colorScheme.surface, // background kartu adaptif
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: borderColor.withAlpha(((hasFocus ? 0.9 : 0.6) * 255).toInt()),
              width: hasFocus ? 1.2 : 1,
            ),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          elevation: hasFocus ? 4 : (_hover ? 2 : 0), // efek depth saat hover/focus
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label di atas input
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    widget.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // TextFormField mengikuti InputDecorationTheme (light/dark)
                Focus(
                  focusNode: _focusNode,
                  child: TextFormField(
                    controller: widget.controller,
                    maxLines: widget.maxLines ?? 1,
                    validator: (v) => v == null || v.isEmpty ? '${widget.label} Required' : null,
                    style: theme.textTheme.bodyMedium, // ikut theme
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      // biarkan fill/border dari theme (kita sudah styling di ThemeData)
                      // tapi tambahkan prefix padding kecil agar rapi
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
