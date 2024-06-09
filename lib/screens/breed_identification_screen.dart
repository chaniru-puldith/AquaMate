import 'dart:io';

import 'package:aquamate/models/fish_data_model.dart';
import 'package:aquamate/screens/fish_details_screen.dart';
import 'package:aquamate/utils/constants.dart';
import 'package:aquamate/widgets/rounded_filled_button.dart';
import 'package:aquamate/widgets/rounded_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class BreedIdentificationScreen extends StatefulWidget {
  const BreedIdentificationScreen({super.key});

  @override
  State<BreedIdentificationScreen> createState() =>
      _BreedIdentificationScreenState();
}

class _BreedIdentificationScreenState extends State<BreedIdentificationScreen> {
  String selectedBreedImagePath = '';
  final picker = ImagePicker();
  bool _isFound = false;
  String breed = '';

  @override
  void initState() {
    super.initState();
    _tfLteInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: kBarrierColor,
        builder: (BuildContext context) {
          double screenWidth = MediaQuery.of(context).size.width;
          return AlertDialog(
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
                      Icons.info_outline_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Alert!',
                    textAlign: TextAlign.center,
                    style: kPoppinsHeadlineStyle.copyWith(
                        fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                      'Please upload an image with only one subject. Images with multiple subjects, crowded scenes, or blurry content may result in incorrect predictions. Ensure the subject is clear and well-lit for the best accuracy in our predictions.',
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
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Got it',
                              style: kFilledButtonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Future<void> _tfLteInit() async {
    await Tflite.loadModel(
      model: "assets/model/fish_breed.tflite",
      labels: "assets/model/breed_labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  _pickImage(ImageSource source) async {
    selectedBreedImagePath = '';

    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    setState(() {
      selectedBreedImagePath = image.path;
    });

    _getBreed(context);
  }

  void _showBreedImagePicker(BuildContext context) {
    showModalBottomSheet(
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0XFF212121),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Material(
                        color: const Color(0XFF212121),
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_library_outlined,
                                  color: Colors.white70,
                                  size: 22.0,
                                ),
                                kSizedBoxW10,
                                Text(
                                  "Gallery",
                                  textAlign: TextAlign.center,
                                  style: kFilledButtonTextStyle.copyWith(
                                    color: Colors.white70,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            _pickImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(
                        color: Colors.white12,
                      ),
                    ),
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Material(
                        color: const Color(0XFF212121),
                        child: InkWell(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white70,
                                  size: 22.0,
                                ),
                                kSizedBoxW10,
                                Text(
                                  "Camera",
                                  textAlign: TextAlign.center,
                                  style: kFilledButtonTextStyle.copyWith(
                                    color: Colors.white70,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            _pickImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ))
                  ],
                )),
          );
        });
  }

  void _getBreed(BuildContext context) {
    showDialog(
        barrierColor: kBarrierColor,
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(30),
            content: Container(
              padding: const EdgeInsets.all(20),
              width: 300,
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
                  child: selectedBreedImagePath.isEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(
                            Icons.account_circle_outlined,
                            color: Colors.black,
                            size: 70,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
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
                      numResults: 4,
                      threshold: 0.9,
                      imageMean: 0,
                      imageStd: 1,
                    );

                    setState(() {
                      if (output == null || output.isEmpty) {
                        breed = 'No matches found';
                        _isFound = true;
                      } else {
                        breed = output[0]['label'];
                        _isFound = true;
                        print(output);
                      }
                    });

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
                    setState(() {
                      selectedBreedImagePath = '';
                    });
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
            content: Align(
              child: SizedBox(
                width: 300,
                height: 300,
                child: SpinKitWaveSpinner(
                  size: 60,
                  color: kPrimaryThemeColor,
                  trackColor: kPrimaryThemeColor.withOpacity(0.5),
                  waveColor: Colors.blue.shade300.withOpacity(0.8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Breed Identification',
          textAlign: TextAlign.center,
          style: kHeadlineTextStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              kSizedBoxH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: kPrimaryThemeColor.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade800, blurRadius: 5),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: selectedBreedImagePath.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.fileCircleXmark,
                                    color: kTextFieldUtilsColor,
                                    size: 100,
                                  ),
                                  kSizedBoxH10,
                                  Text('No image file selected'),
                                ],
                              )
                            : ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                child: Image.file(
                                  File(selectedBreedImagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              kSizedBoxH30,
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 55,
                child: RoundedFilledButton(
                  onPressed: () {
                    _showBreedImagePicker(context);
                  },
                  child: const Text(
                    'Select an Image',
                    style: kFilledButtonTextStyle,
                  ),
                ),
              ),
              kSizedBoxH30,
              kSizedBoxH30,
              Visibility(
                visible: _isFound,
                child: Column(
                  children: [
                    Text(
                      'Predicted Breed :  $breed',
                      style: kPoppinsBoldTextStyle,
                    ),
                    kSizedBoxH20,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 55,
                      child: Visibility(
                        visible: breed != 'No matches found',
                        child: RoundedOutlinedButton(
                          onPressed: () {
                            switch (breed) {
                              case 'Angelfish':
                                final fish = FishData.fromJson(angleJson);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FishDetailsScreen(
                                      data: fish,
                                    ),
                                  ),
                                );
                                break;
                              case 'Arowana':
                                final fish = FishData.fromJson(arowanaJson);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FishDetailsScreen(
                                      data: fish,
                                    ),
                                  ),
                                );
                                break;
                              case 'Goldfish':
                                final fish = FishData.fromJson(goldFishJson);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FishDetailsScreen(
                                      data: fish,
                                    ),
                                  ),
                                );
                                break;
                              case 'Oscar':
                                final fish = FishData.fromJson(oscarJson);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FishDetailsScreen(
                                      data: fish,
                                    ),
                                  ),
                                );
                                break;
                            }
                          },
                          child: const Text(
                            'Get More Details',
                            style: kOutlinedButtonTextStyle,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
