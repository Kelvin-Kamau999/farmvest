import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.errorText,
      this.labelText,
      this.fillColor,
      this.outlineColor,
      this.keyboardType = TextInputType.text,
      this.isPassword = false,
      required this.hintText})
      : super(key: key);
  final TextEditingController controller;
  final String? errorText;
  final String hintText;
  final Color? fillColor;
  final Color? outlineColor;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool? isPassword;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (val) {
        if (val!.isEmpty) {
          return widget.errorText ?? 'Field cannot be empty';
        }

        return null;
      },
      obscureText: isObscure && widget.isPassword!,
      style:
          TextStyle(color: widget.outlineColor ?? Colors.black, fontSize: 14),
      maxLength: null,
      keyboardType: widget.keyboardType,
      maxLines: isObscure ? 1 : null,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword!
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                  isObscure ? Icons.visibility : Icons.visibility_off,
                  color: widget.outlineColor ?? Colors.black,
                ),
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        isDense: true,
        labelText: widget.labelText ?? widget.hintText,
        labelStyle: TextStyle(
          fontSize: 14,
          color: widget.outlineColor ??
              const Color(0xFF1A1A1A).withOpacity(0.2494),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: widget.outlineColor ??
              const Color(0xFF1A1A1A).withOpacity(0.2494),
        ),
        focusedBorder: widget.outlineColor != null
            ? focusedBorder.copyWith(
                borderSide: BorderSide(
                  color: widget.outlineColor!,
                ),
              )
            : focusedBorder,
        border: widget.outlineColor != null
            ? outlineBorder.copyWith(
                borderSide: BorderSide(
                  color: widget.outlineColor!,
                ),
              )
            : outlineBorder,
        errorBorder: errorBorder,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(
            color:
                widget.outlineColor ?? const Color(0xFF1A1A1A).withOpacity(0.1),
            width: 1,
          ),
        ),
        fillColor: widget.fillColor ?? Colors.white,
        filled: widget.fillColor != null,
      ),
    );
  }
}
