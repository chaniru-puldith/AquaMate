import 'package:aquamate/utils/constants.dart';
import 'package:flutter/material.dart';

class RoundedFilledButton extends StatelessWidget {
  const RoundedFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.shrinkWrap = false,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      materialTapTargetSize: shrinkWrap
          ? MaterialTapTargetSize.shrinkWrap
          : MaterialTapTargetSize.padded,
      onPressed: onPressed,
      fillColor: kPrimaryThemeColor,
      child: child,
    );
  }
}
