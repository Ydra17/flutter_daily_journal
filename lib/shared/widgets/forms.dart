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

class CustomTextField2 extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLines; // Default to single line, can be adjusted if needed
  const CustomTextField2({super.key, required this.controller, required this.label, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Agar label rata kiri
        children: [
          // Menambahkan label di atas form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label, // Menampilkan label
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(179, 0, 0, 0), // 0.7 * 255 = 178.5 ≈ 179
              ),
            ),
          ),
          // Form input (TextFormField)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: controller,
              maxLines: maxLines ?? 1, // Default to single line if not specified
              validator: (value) => value == null || value.isEmpty ? '$label Required' : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
