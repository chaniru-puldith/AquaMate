import 'package:flutter/material.dart';

class AboutIconCardButton extends StatelessWidget {
  const AboutIconCardButton({
    super.key,
    required this.onPress,
    required this.image,
    required this.text,
  });

  final VoidCallback onPress;
  final Image image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        elevation: 0,
        fillColor: Colors.white,
        constraints: BoxConstraints.tight(const Size(120, 130)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: onPress,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: image,
              ),
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
