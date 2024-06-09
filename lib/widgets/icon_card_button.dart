import 'package:aquamate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        gradient: const LinearGradient(
          colors: [Color(0xFF050505), Color(0xFF101010), Color(0xFF151515)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: kPrimaryThemeColor.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kPrimaryThemeColor.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: RawMaterialButton(
        elevation: 0,
        hoverElevation: 5,
        highlightElevation: 5,
        onPressed: onPress,
        // fillColor: const Color(0xFF212121),
        constraints: BoxConstraints.tight(const Size(160, 150)),
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.blueGrey.shade100),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: kPrimaryThemeColor.withOpacity(0.8),
                size: 80,
              ),
              kSizedBoxH10,
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.tiltNeon(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
