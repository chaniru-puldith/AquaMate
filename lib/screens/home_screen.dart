import 'dart:io';

import 'package:aquamate/models/fish_data_model.dart';
import 'package:aquamate/screens/breed_identification_screen.dart';
import 'package:aquamate/screens/fish_details_screen.dart';
import 'package:aquamate/utils/constants.dart';
import 'package:aquamate/widgets/about_card_button.dart';
import 'package:aquamate/widgets/about_icon_card_button.dart';
import 'package:aquamate/widgets/icon_card_button.dart';
import 'package:aquamate/widgets/rounded_filled_button.dart';
import 'package:aquamate/widgets/rounded_outlined_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
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

  // void _showBreedImagePicker(BuildContext context) {
  //   showModalBottomSheet(
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       builder: (builder) {
  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Container(
  //               width: MediaQuery.of(context).size.width,
  //               height: MediaQuery.of(context).size.height / 5.2,
  //               margin: const EdgeInsets.only(top: 8.0),
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  //               decoration: BoxDecoration(
  //                 color: kSecondaryColor,
  //                 borderRadius: BorderRadius.circular(25),
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Expanded(
  //                       child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(15),
  //                     child: Material(
  //                       color: kSecondaryColor,
  //                       child: InkWell(
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(horizontal: 10),
  //                           child: Row(
  //                             children: [
  //                               const Icon(
  //                                 Icons.photo_library_outlined,
  //                                 size: 22.0,
  //                               ),
  //                               kSizedBoxW10,
  //                               Text(
  //                                 "Gallery",
  //                                 textAlign: TextAlign.center,
  //                                 style: kFilledButtonTextStyle.copyWith(
  //                                   color: Colors.black,
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           _imgBreedFromGallery();
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                     ),
  //                   )),
  //                   const Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                     child: Divider(
  //                       color: Colors.black12,
  //                     ),
  //                   ),
  //                   Expanded(
  //                       child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(15),
  //                     child: Material(
  //                       color: kSecondaryColor,
  //                       child: InkWell(
  //                         child: Padding(
  //                           padding:
  //                               const EdgeInsets.symmetric(horizontal: 10.0),
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               const Icon(
  //                                 Icons.camera_alt_outlined,
  //                                 size: 22.0,
  //                               ),
  //                               kSizedBoxW10,
  //                               Text(
  //                                 "Camera",
  //                                 textAlign: TextAlign.center,
  //                                 style: kFilledButtonTextStyle.copyWith(
  //                                   color: Colors.black,
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           print('hello');
  //                           _imgBreedFromCamera();
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                     ),
  //                   ))
  //                 ],
  //               )),
  //         );
  //       });
  // }
  //
  // void _showDiseaseImagePicker(BuildContext context) {
  //   showModalBottomSheet(
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       builder: (builder) {
  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Container(
  //               width: MediaQuery.of(context).size.width,
  //               height: MediaQuery.of(context).size.height / 5.2,
  //               margin: const EdgeInsets.only(top: 8.0),
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  //               decoration: BoxDecoration(
  //                   color: kSecondaryColor,
  //                   borderRadius: BorderRadius.circular(25)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Expanded(
  //                       child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(15),
  //                     child: Material(
  //                       color: kSecondaryColor,
  //                       child: InkWell(
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(horizontal: 10),
  //                           child: Row(
  //                             children: [
  //                               const Icon(
  //                                 Icons.photo_library_outlined,
  //                                 size: 22.0,
  //                               ),
  //                               kSizedBoxW10,
  //                               Text(
  //                                 "Gallery",
  //                                 textAlign: TextAlign.center,
  //                                 style: kFilledButtonTextStyle.copyWith(
  //                                     color: Colors.black),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           _imgDiseaseFromGallery();
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                     ),
  //                   )),
  //                   const Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                     child: Divider(
  //                       color: Colors.black12,
  //                     ),
  //                   ),
  //                   Expanded(
  //                       child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(15),
  //                     child: Material(
  //                       color: kSecondaryColor,
  //                       child: InkWell(
  //                         child: Padding(
  //                           padding:
  //                               const EdgeInsets.symmetric(horizontal: 10.0),
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               const Icon(
  //                                 Icons.camera_alt_outlined,
  //                                 size: 22.0,
  //                               ),
  //                               kSizedBoxW10,
  //                               Text(
  //                                 "Camera",
  //                                 textAlign: TextAlign.center,
  //                                 style: kFilledButtonTextStyle.copyWith(
  //                                   color: Colors.black,
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           _imgDiseaseFromCamera();
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                     ),
  //                   ))
  //                 ],
  //               )),
  //         );
  //       });
  // }

  void _showLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: const Align(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void getBreed(BuildContext context) {
    showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(30),
            backgroundColor: Colors.transparent,
            content: Container(
              padding: const EdgeInsets.all(20),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                kSizedBoxH10,
                const Text(
                  'Selected Photo',
                  style: kFilledButtonTextStyle,
                ),
                kSizedBoxH10,
                SizedBox(
                  width: 120,
                  height: 120,
                  child: selectedBreedImageFile == null
                      ? CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(
                            Icons.account_circle_outlined,
                            color: Colors.black,
                            size: 70,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.file(
                            File(selectedBreedImagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                kSizedBoxH20,
                RoundedFilledButton(
                  onPressed: () async {
                    _showLoading(context);

                    var output = await Tflite.runModelOnImage(
                      path: selectedBreedImagePath,
                      numResults:
                          7, // The number of classes your model predicts
                      threshold:
                          0.1, // Adjust this threshold as needed based on your model's confidence
                      imageMean:
                          0, // Default is 0 if you haven't applied any specific normalization during training
                      imageStd:
                          1, // Default is 1 if you haven't applied any specific normalization during training
                    );

                    // var recognitions = await Tflite.runModelOnImage(
                    //     path: selectedBreedImagePath, // required
                    //     imageMean: 280.0, // defaults to 117.0
                    //     imageStd: 1.0, // defaults to 1.0
                    //     numResults: 7, // defaults to 5
                    //     threshold: 0.5, // defaults to 0.1
                    //     asynch: true // defaults to true
                    //     );

                    if (output == null || output.isEmpty) {
                      print('No matches');
                    }

                    print(output);

                    if (!mounted) return;
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Get Results',
                    style: kFilledButtonTextStyle.copyWith(fontSize: 12),
                  ),
                ),
                RoundedOutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Discard',
                    style: kOutlinedButtonTextStyle.copyWith(fontSize: 12),
                  ),
                )
              ]),
            ),
          );
        });
  }

  void getDisease(BuildContext context) {
    showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(30),
            backgroundColor: Colors.transparent,
            content: Container(
              padding: const EdgeInsets.all(20),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                kSizedBoxH10,
                const Text(
                  'Selected Photo',
                  style: kFilledButtonTextStyle,
                ),
                kSizedBoxH10,
                SizedBox(
                  width: 120,
                  height: 120,
                  child: selectedBreedImageFile == null
                      ? CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(
                            Icons.account_circle_outlined,
                            color: Colors.black,
                            size: 70,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.file(
                            File(selectedBreedImagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                kSizedBoxH20,
                RoundedFilledButton(
                  onPressed: () async {
                    // await _tfLteInit();
                    _showLoading(context);

                    // var recognitions = await Tflite.runModelOnImage(
                    //     path: selectedImagePath, // required
                    //     imageMean: 125.0, // defaults to 117.0
                    //     imageStd: 1.0, // defaults to 1.0
                    //     numResults: 5, // defaults to 5
                    //     threshold: 0.5, // defaults to 0.1
                    //     asynch: true // defaults to true
                    //     );

                    var recognitions = await Tflite.runModelOnImage(
                        path: selectedDiseaseImagePath, // required
                        imageMean: 0.0, // defaults to 117.0
                        imageStd: 255.0, // defaults to 1.0
                        numResults: 5, // defaults to 5
                        threshold: 0.2, // defaults to 0.1
                        asynch: true // defaults to true
                        );

                    if (recognitions == null) {
                      print('No matches');
                    }

                    Tflite.close();

                    print(recognitions);

                    if (!mounted) return;
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Get Results',
                    style: kFilledButtonTextStyle.copyWith(fontSize: 12),
                  ),
                ),
                RoundedOutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Discard',
                    style: kOutlinedButtonTextStyle.copyWith(fontSize: 12),
                  ),
                )
              ]),
            ),
          );
        });
  }

  _imgBreedFromGallery() async {
    selectedBreedImageFile = null;
    selectedBreedImagePath = '';

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);
    setState(() {
      selectedBreedImageFile = imageMap;
      selectedBreedImagePath = image.path;
    });

    getBreed(context);
  }

  _imgDiseaseFromCamera() async {
    selectedBreedImageFile = null;
    selectedBreedImagePath = '';

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);
    setState(() {
      selectedBreedImageFile = imageMap;
      selectedBreedImagePath = image.path;
    });

    getDisease(context);
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
                backgroundColor: Colors.white,
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
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
                    ),
                    PopupMenuButton(
                      padding: EdgeInsets.zero,
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
                                      backgroundColor: Colors.white,
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
                              Text('Sign Out'),
                              Icon(
                                Icons.logout_outlined,
                                color: Colors.black,
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
                    color: kPrimaryThemeColor.withOpacity(0.1),
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
                      onPress: () {
                        // selectedBreedImageFile = null;
                        // selectedBreedImagePath = '';
                        // _showBreedImagePicker(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const BreedIdentificationScreen()));
                      },
                      icon: FontAwesomeIcons.magnifyingGlass,
                      text: 'Identify Fish Breeds',
                    ),
                    IconCardButton(
                      onPress: () async {
                        selectedDiseaseImageFile = null;
                        selectedDiseaseImagePath = '';
                        // _showDiseaseImagePicker(context);
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore about fish breeds",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    AboutIconCardButton(
                      onPress: () {
                        final fish = FishData.fromJson(angleJson);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FishDetailsScreen(
                              image: Image.asset(
                                'assets/images/angel.jpg',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              data: fish,
                            ),
                          ),
                        );
                      },
                      image: Image.asset('assets/images/angel.jpg'),
                      text: 'Angelfish',
                    ),
                    AboutIconCardButton(
                      onPress: () {
                        final fish = FishData.fromJson(arowanaJson);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FishDetailsScreen(
                              image: Image.asset(
                                'assets/images/arowana.jpg',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              data: fish,
                            ),
                          ),
                        );
                      },
                      image: Image.asset('assets/images/arowana.jpg'),
                      text: 'Arowana',
                    ),
                    AboutIconCardButton(
                      onPress: () {
                        final fish = FishData.fromJson(goldFishJson);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FishDetailsScreen(
                              image: Image.asset(
                                'assets/images/goldfish.jpg',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              data: fish,
                            ),
                          ),
                        );
                      },
                      image: Image.asset('assets/images/goldfish.jpg'),
                      text: 'Goldfish',
                    ),
                    AboutIconCardButton(
                      onPress: () {
                        final fish = FishData.fromJson(oscarJson);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FishDetailsScreen(
                              image: Image.asset(
                                'assets/images/oscar.jpg',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              data: fish,
                            ),
                          ),
                        );
                      },
                      image: Image.asset(
                        'assets/images/oscar.jpg',
                        fit: BoxFit.cover,
                      ),
                      text: 'Oscar',
                    )
                  ],
                ),
              ),
              kSizedBoxH20,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore about fish diseases",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    AboutCardButton(onPress: () {}, text: "Fish Disease"),
                    AboutCardButton(onPress: () {}, text: "Fish Disease"),
                    AboutCardButton(onPress: () {}, text: "Fish Disease"),
                    AboutCardButton(onPress: () {}, text: "Fish Disease"),
                    AboutCardButton(onPress: () {}, text: "Fish Disease"),
                    AboutCardButton(onPress: () {}, text: "Fish Disease"),
                  ],
                ),
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
