import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? listTextInputFormatter;
  final IconData? suffixIcon;
  final String? initialValue;
  final double? width;
  final bool? isTopField; // La idea es que tenga bordes redondeados arriba
  final bool? isBottomField;
  final bool? readOnly;

  CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.listTextInputFormatter,
    this.suffixIcon,
    this.initialValue,
    this.width,
    this.isBottomField,
    this.isTopField,
    this.readOnly = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    const borderRadius = Radius.circular(15);

    return Container(
      // padding: const EdgeInsets.only(bottom: 0, top: 15),
      width: widget.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: widget.isTopField == null || widget.isTopField == true
                ? borderRadius
                : Radius.zero,
            topRight: widget.isTopField == null || widget.isTopField == true
                ? borderRadius
                : Radius.zero,
            bottomLeft:
                widget.isBottomField == null || widget.isBottomField == true
                    ? borderRadius
                    : Radius.zero,
            bottomRight:
                widget.isBottomField == null || widget.isBottomField == true
                    ? borderRadius
                    : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]),
      child: TextFormField(
        readOnly: widget.readOnly!,
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        inputFormatters: widget.listTextInputFormatter,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
          label: widget.label != null ? Text(widget.label!) : null,
          hintText: widget.hint,
          errorText: widget.errorMessage,
          focusColor: colors.primary,
          suffix: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  child: Icon(
                    widget.suffixIcon,
                    color: colors.primary,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
