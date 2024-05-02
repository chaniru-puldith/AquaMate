import 'dart:io';

import 'package:aquamate/utils/constants.dart';
import 'package:aquamate/widgets/rounded_filled_button.dart';
import 'package:aquamate/widgets/rounded_outlined_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  DateTime? currentBackPressTime;

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
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 89,
                                        child: Image.asset(
                                            'assets/images/aquamateLogo.png'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 47,
                                  ),
                                  const Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Welcome!',
                                            style: kPoppinsHeadlineStyle,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                'Enjoy the features by signing in to the AQUAMATE',
                                                style:
                                                    kPoppinsWelcomeDescriptionStyle,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    width: 263,
                                    height: 56,
                                    child: RoundedFilledButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/signin');
                                      },
                                      child: const Text(
                                        'Sign In',
                                        style: kFilledButtonTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                                kSizedBoxH10,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    width: 263,
                                    height: 56,
                                    child: RoundedOutlinedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/signup');
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: kOutlinedButtonTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'aquamate',
                    style: TextStyle(fontSize: 11, color: kTextFieldUtilsColor),
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
