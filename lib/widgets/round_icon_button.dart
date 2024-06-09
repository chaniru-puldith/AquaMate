import 'package:aquamate/utils/constants.dart';
import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPress;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(
        width: 40.0,
        height: 40.0,
      ),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF31343D),
      splashColor: kPrimaryThemeColor.withOpacity(0.15),
      onPressed: onPress,
      child: Icon(
        icon,
        size: 20,
        color: const Color(0xFF959595),
      ),
    );
  }
}
