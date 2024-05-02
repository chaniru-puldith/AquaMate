import 'package:aquamate/utils/constants.dart';
import 'package:flutter/material.dart';

class IconCardButton extends StatelessWidget {
  const IconCardButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.text,
  });

  final VoidCallback onPress;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kPrimaryThemeColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: RawMaterialButton(
        elevation: 0,
        onPressed: onPress,
        fillColor: Colors.white,
        constraints: BoxConstraints.tight(const Size(160, 160)),
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.blueGrey.shade100),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 80,
                color: kPrimaryThemeColor,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
