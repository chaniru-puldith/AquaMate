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
  File? selectedBreedImageFile;
  String selectedBreedImagePath = '';
  final picker = ImagePicker();
  bool _isFound = false;
  String breed = '';

  @override
  void initState() {
    super.initState();
    _tfLteInit();
  }

  Future<void> _tfLteInit() async {
    String? res = await Tflite.loadModel(
        model: "assets/model/fish_breed.tflite",
        labels: "assets/model/breed_labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  _pickImage(ImageSource source) async {
    selectedBreedImageFile = null;
    selectedBreedImagePath = '';

    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    var imageMap = File(image.path);
    setState(() {
      selectedBreedImageFile = imageMap;
      selectedBreedImagePath = image.path;
    });

    _getBreed(context);
  }

  void _showBreedImagePicker(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Material(
                        color: kSecondaryColor,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_library_outlined,
                                  size: 22.0,
                                ),
                                kSizedBoxW10,
                                Text(
                                  "Gallery",
                                  textAlign: TextAlign.center,
                                  style: kFilledButtonTextStyle.copyWith(
                                    color: Colors.black,
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
                        color: Colors.black12,
                      ),
                    ),
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Material(
                        color: kSecondaryColor,
                        child: InkWell(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 22.0,
                                ),
                                kSizedBoxW10,
                                Text(
                                  "Camera",
                                  textAlign: TextAlign.center,
                                  style: kFilledButtonTextStyle.copyWith(
                                    color: Colors.black,
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
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(30),
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
                      numResults:
                          5, // The number of classes your model predicts
                      threshold:
                          0.1, // Adjust this threshold as needed based on your model's confidence
                      imageMean:
                          0, // Default is 0 if you haven't applied any specific normalization during training
                      imageStd:
                          1, // Default is 1 if you haven't applied any specific normalization during training
                    );

                    if (output == null || output.isEmpty) {
                      print('No matches');
                    }

                    setState(() {
                      breed = output![0]['label'];
                      _isFound = true;
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
                      selectedBreedImageFile = null;
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
                    child: Card(
                      elevation: 6,
                      shadowColor: kPrimaryThemeColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: selectedBreedImageFile == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.fileCircleXmark,
                                    size: 100,
                                  ),
                                  kSizedBoxH10,
                                  Text('No image file selected'),
                                ],
                              )
                            : Image.file(
                                File(selectedBreedImagePath),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              kSizedBoxH20,
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
                      style: kHeadlineTextStyle,
                    ),
                    kSizedBoxH20,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 55,
                      child: RoundedOutlinedButton(
                          onPressed: () {
                            switch (breed) {
                              case 'Angelfish':
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
                                break;
                              case 'Arowana':
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
                                break;
                              case 'Goldfish':
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
                                break;
                              case 'Oscar':
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
                                break;
                            }
                          },
                          child: const Text(
                            'View Details',
                            style: kOutlinedButtonTextStyle,
                          )),
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
