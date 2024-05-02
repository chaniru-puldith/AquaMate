import 'package:aquamate/utils/constants.dart';
import 'package:flutter/material.dart';

class RoundedOutlinedButton extends StatelessWidget {
  const RoundedOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: kPrimaryThemeColor,
          ),
          borderRadius: BorderRadius.circular(15)),
      onPressed: onPressed,
      child: child,
    );
  }
}
