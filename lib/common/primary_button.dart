import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      this.text,
      this.onTap,
      this.child,
      this.textColor = Colors.white,
      this.color = kPrimaryColor,
      this.isLoading = false})
      : super(key: key);

  final String? text;
  final Widget? child;
  final Function? onTap;
  final Color? color;
  final Color? textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null && !isLoading) {
          onTap!();
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 49,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : child ??
                    Text(
                      text!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
