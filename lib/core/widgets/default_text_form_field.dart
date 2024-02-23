import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIcon;
  final bool obscureText;
  final Function(String?)? onChanged;
  final Function(String?)? onSubmit;
  final String errorText;

  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    required this.textInputAction,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixIcon,
    this.onChanged,
    this.onSubmit,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: IconButton(
          onPressed: onSuffixIcon,
          icon: Icon(
            suffixIcon,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary)),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }
}
