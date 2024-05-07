import 'dart:io';

import 'package:aquamate/models/fish_data_model.dart';
import 'package:aquamate/screens/breed_identification_screen.dart';
import 'package:aquamate/screens/disease_detection_screen.dart';
import 'package:aquamate/utils/constants.dart';
import 'package:aquamate/widgets/about_icon_card_button.dart';
import 'package:aquamate/widgets/icon_card_button.dart';
import 'package:aquamate/widgets/rounded_filled_button.dart';
import 'package:aquamate/widgets/rounded_outlined_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance;
  final picker = ImagePicker();
  late User _loggedInUser;
  String userName = '';
  DateTime? currentBackPressTime;
  File? selectedBreedImageFile;
  File? selectedDiseaseImageFile;
  String selectedBreedImagePath = '';
  String selectedDiseaseImagePath = '';
  String label = '';
  double confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _database.ref('users/${_loggedInUser.uid}/name').onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          userName = event.snapshot.value.toString();
        });
      }
    });
  }

  void _getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _loggedInUser = user;
        if (kDebugMode) {
          print(_loggedInUser.email.toString());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didChange) async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          return Future.value(false);
        }
        await showDialog(
          barrierDismissible: false,
          context: context,
          barrierColor: kBarrierColor,
          builder: (BuildContext context) {
            double screenWidth = MediaQuery.of(context).size.width;
            return PopScope(
              canPop: false,
              child: AlertDialog(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                content: Container(
                  width: screenWidth,
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 102,
                        width: 102,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xFFFFCD6D),
                        ),
                        child: const Icon(
                          Icons.question_mark_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Exit?',
                        textAlign: TextAlign.center,
                        style: kPoppinsHeadlineStyle.copyWith(
                            fontSize: 19, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text('Are you sure you want to exit?',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: TextStyle(color: kSecondaryTextColor)),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: RoundedFilledButton(
                                onPressed: () {
                                  exit(0);
                                },
                                child: const Text(
                                  'Yes',
                                  style: kFilledButtonTextStyle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: RoundedOutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'No',
                                  style: kOutlinedButtonTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, $userName 👋',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const Text(
                          'Welcome to AquaMate!',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      padding: EdgeInsets.zero,
                      color: const Color(0xFF212121),
                      iconColor: const Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          onTap: () async {
                            await showDialog(
                                barrierDismissible: false,
                                context: context,
                                barrierColor: kBarrierColor,
                                builder: (BuildContext context) {
                                  double screenWidth =
                                      MediaQuery.of(context).size.width;
                                  return PopScope(
                                    canPop: false,
                                    child: AlertDialog(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      content: Container(
                                        width: screenWidth,
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 102,
                                              width: 102,
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: const Color(0xFFFFCD6D),
                                              ),
                                              child: const Icon(
                                                Icons.question_mark_rounded,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            Text(
                                              'Sign Out?',
                                              textAlign: TextAlign.center,
                                              style: kPoppinsHeadlineStyle
                                                  .copyWith(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w900),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            const Text(
                                                'Are you sure you want to Sign Out?',
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.visible,
                                                style: TextStyle(
                                                    color:
                                                        kSecondaryTextColor)),
                                            const SizedBox(height: 25),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    height: 55,
                                                    child: RoundedFilledButton(
                                                      onPressed: () async {
                                                        await FirebaseAuth
                                                            .instance
                                                            .signOut();
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        Navigator
                                                            .pushNamedAndRemoveUntil(
                                                          context,
                                                          "/welcome",
                                                          ModalRoute.withName(
                                                              "/"),
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Yes',
                                                        style:
                                                            kFilledButtonTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 100,
                                                    height: 55,
                                                    child:
                                                        RoundedOutlinedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'No',
                                                        style:
                                                            kOutlinedButtonTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Sign Out',
                                style: TextStyle(color: Color(0xFFF5F5F5)),
                              ),
                              Icon(
                                Icons.logout_outlined,
                                color: Color(0xFFF5F5F5),
                                size: 17,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              kSizedBoxH30,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        kPrimaryThemeColor.withOpacity(0.3),
                        kPrimaryThemeColor.withOpacity(0.1)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "AquaMate",
                            style: GoogleFonts.tiltNeon(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Image.asset(
                            'assets/images/fish.png',
                            width: 30,
                            height: 30,
                          ),
                        ],
                      ),
                      kSizedBoxH10,
                      Text(
                        "AquaMate is a AI powered mobile application that enables you to identify ornamental fish breeds and disease with ease.",
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.dmSans(
                          color: Colors.blueGrey,
                          fontSize: 13,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              kSizedBoxH20,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconCardButton(
                      onPress: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const BreedIdentificationScreen()));
                      },
                      icon: FontAwesomeIcons.magnifyingGlass,
                      text: 'Identify Fish Breeds',
                    ),
                    IconCardButton(
                      onPress: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const DiseaseDetectionScreen()));
                      },
                      icon: FontAwesomeIcons.virusCovid,
                      text: 'Detect Fish Diseases',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Explore about fish breeds",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.expand_circle_down_outlined,
                      color: kPrimaryThemeColor.withOpacity(0.3),
                      size: 20,
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  AboutIconCardButton(
                    fishData: FishData.fromJson(angleJson),
                  ),
                  AboutIconCardButton(
                    fishData: FishData.fromJson(arowanaJson),
                  ),
                  AboutIconCardButton(
                    fishData: FishData.fromJson(goldFishJson),
                  ),
                  AboutIconCardButton(
                    fishData: FishData.fromJson(oscarJson),
                  )
                ],
              ),
              kSizedBoxH20,
            ],
          ),
        ),
      ),
    );
  }
}

Uint8List imageToByteListFloat32(
    String imagePath, int inputSize, double mean, double std) {
  // Read image file from the path
  File file = File(imagePath);
  img.Image? image = img.decodeImage(file.readAsBytesSync());

  // Check if the image is null
  if (image == null) {
    throw Exception('Failed to decode image.');
  }

  var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (var i = 0; i < inputSize; i++) {
    for (var j = 0; j < inputSize; j++) {
      var pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
      buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
      buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
    }
  }
  return convertedBytes.buffer.asUint8List();
}
