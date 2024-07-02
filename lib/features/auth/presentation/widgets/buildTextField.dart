import 'package:flutter/material.dart';

Widget buildTextField(
    {required TextEditingController controller,
    required String title,
    required IconData icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      validator: (val) {
        if (val == null) {
          return "$title can'\t be empty";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
          labelText: title,
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          prefixIcon: Icon(icon)),
    ),
  );
}
