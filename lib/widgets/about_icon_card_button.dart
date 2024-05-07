import 'package:aquamate/models/fish_data_model.dart';
import 'package:aquamate/screens/fish_details_screen.dart';
import 'package:aquamate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutIconCardButton extends StatelessWidget {
  const AboutIconCardButton({
    super.key,
    required this.fishData,
  });

  final FishData fishData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black, Color(0xFF151515)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: kPrimaryThemeColor.withOpacity(0.1),
            width: 3,
          ),
        ),
        child: RawMaterialButton(
          elevation: 0,
          constraints: BoxConstraints.tight(const Size(120, 130)),
          padding: const EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FishDetailsScreen(
                  data: fishData,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      fishData.image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  kSizedBoxW10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kSizedBoxH10,
                      Text(
                        fishData.fishName,
                        style: GoogleFonts.tiltNeon(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        fishData.scientificName,
                        style: GoogleFonts.tiltNeon(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: kPrimaryThemeColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: kPrimaryThemeColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ]),
                  width: 90,
                  child: const Text(
                    'More Details',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
