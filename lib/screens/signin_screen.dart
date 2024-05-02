import 'package:aquamate/utils/constants.dart';
import 'package:aquamate/widgets/rounded_filled_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  final _auth = FirebaseAuth.instance;
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool passwordToggle = false;
  String password = '';
  String email = '';
  bool isPasswordMatching = true;
  bool isLoading = false;
  bool isEmailTapped = false;
  bool isPwdTapped = false;
  String errorMessage = '';
  Color pwdFocusedIconColor = kPrimaryColor;
  Color emailFocusedIconColor = kPrimaryColor;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String _validateInputs() {
    if (email.isEmpty && password.isEmpty) {
      setState(() {
        isPwdTapped = false;
        emailFocusedIconColor = kErrorColor;
        pwdFocusedIconColor = kErrorColor;
      });
      return "Please enter email and password";
    } else if (email.isEmpty) {
      setState(() {
        isPwdTapped = false;
        emailFocusedIconColor = kErrorColor;
      });
      return "Please enter your email";
    } else if (!_isValidEmail(email)) {
      setState(() {
        isPwdTapped = false;
        emailFocusedIconColor = kErrorColor;
      });
      return "Invalid email address";
    } else if (password.isEmpty) {
      setState(() {
        isPwdTapped = false;
        pwdFocusedIconColor = kErrorColor;
      });
      return "Please enter your password";
    } else {
      return "";
    }
  }

  void _showSigninSuccessDialog(BuildContext context) {
    showDialog(
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
                      color: kSuccessColor,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Good to see you!',
                    textAlign: TextAlign.center,
                    style: kPoppinsHeadlineStyle.copyWith(fontSize: 19),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text('You have successfully logged into the AQUAMATE.',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: TextStyle(color: kSecondaryTextColor)),
                  const SizedBox(height: 25),
                ],
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Sign In",
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/aquamateLogo.png',
                    height: 50,
                  ),
                  kSizedBoxH20,
                  const SizedBox(
                    width: 290,
                    child: Text(
                      'Please sign in to your account using email and password',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    height: 57,
                    child: TextField(
                      controller: _emailController,
                      focusNode: _focusNodes[0],
                      style: kPoppinsRegularTextStyle,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kTextFieldFillColor,
                        hintText: 'Enter Your Email',
                        hintStyle: kPoppinsHintTextStyle,
                        suffixIcon: Visibility(
                          visible: _isValidEmail(email),
                          child: const Icon(
                            size: 20,
                            Icons.check_rounded,
                            color: Color(0xFF13B97D),
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.email_outlined,
                            color:
                                errorMessage.toLowerCase().contains('email') &&
                                        !isEmailTapped
                                    ? kErrorColor
                                    : _focusNodes[0].hasFocus
                                        ? emailFocusedIconColor
                                        : kTextFieldUtilsColor,
                          ),
                        ),
                        enabledBorder:
                            errorMessage.toLowerCase().contains('email') &&
                                    !isEmailTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                        focusedBorder:
                            errorMessage.toLowerCase().contains('email') &&
                                    !isEmailTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                        border: errorMessage.toLowerCase().contains('email') &&
                                !isEmailTapped
                            ? kTextFeildErrorOutlineBorder
                            : kTextFieldOutlineBorder,
                      ),
                      onTap: () {
                        setState(() {
                          isEmailTapped = true;
                          emailFocusedIconColor = kPrimaryThemeColor;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                  ),
                  kSizedBoxH10,
                  SizedBox(
                    height: 57,
                    child: TextField(
                      focusNode: _focusNodes[1],
                      style: kPoppinsRegularTextStyle,
                      obscureText: !passwordToggle,
                      controller: _pwdController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kTextFieldFillColor,
                        hintText: 'Enter Your Password',
                        hintStyle: kPoppinsHintTextStyle,
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordToggle
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: passwordToggle
                                ? kPrimaryThemeColor
                                : kTextFieldUtilsColor,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordToggle = !passwordToggle;
                            });
                          },
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: errorMessage
                                        .toLowerCase()
                                        .contains('password') &&
                                    !isPwdTapped
                                ? kErrorColor
                                : _focusNodes[1].hasFocus
                                    ? pwdFocusedIconColor
                                    : kTextFieldUtilsColor,
                          ),
                        ),
                        enabledBorder:
                            errorMessage.toLowerCase().contains('password') &&
                                    !isPwdTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                        focusedBorder:
                            errorMessage.toLowerCase().contains('password') &&
                                    !isPwdTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                        border:
                            errorMessage.toLowerCase().contains('password') &&
                                    !isPwdTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                      ),
                      onTap: () {
                        setState(() {
                          isPwdTapped = true;
                          pwdFocusedIconColor = kPrimaryThemeColor;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ),
                  kSizedBoxH20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: errorMessage != '',
                        child: SizedBox(
                          width: 215,
                          child: Text(
                            '*$errorMessage',
                            style: kPoppinsErrorTextStyle,
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () async {
                      //     await Future.delayed(Duration(seconds: 3));
                      //     // await Navigator.of(context).push(MaterialPageRoute(
                      //     //     builder: (context) => ForgetPasswordScreen(
                      //     //           email: email,
                      //     //         )));
                      //     _emailController.clear();
                      //     email = '';
                      //   },
                      //   child: const Text(
                      //     'Forgot Password?',
                      //     style: TextStyle(
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  kSizedBoxH20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 56,
                        child: RoundedFilledButton(
                            onPressed: () async {
                              setState(() {
                                isEmailTapped = false;
                                isPwdTapped = false;
                                isLoading = true;
                                errorMessage = '';
                                pwdFocusedIconColor = kPrimaryThemeColor;
                                emailFocusedIconColor = kPrimaryThemeColor;
                              });

                              errorMessage = _validateInputs();

                              if (errorMessage.isEmpty) {
                                try {
                                  await _auth
                                      .signInWithEmailAndPassword(
                                          email: email, password: password)
                                      .timeout(const Duration(seconds: 5));

                                  _pwdController.clear();

                                  if (!mounted) return;

                                  _showSigninSuccessDialog(context);

                                  await Future.delayed(
                                      const Duration(seconds: 3));

                                  if (!mounted) return;

                                  Navigator.pushNamed(context, '/home');
                                } on FirebaseAuthException catch (authError) {
                                  if (authError.code == 'invalid-credential') {
                                    setState(() {
                                      emailFocusedIconColor = kErrorColor;
                                      pwdFocusedIconColor = kErrorColor;
                                      errorMessage =
                                          'Invalid Email or Password';
                                      _pwdController.clear();
                                    });
                                  } else if (authError.code ==
                                      'too-many-requests') {
                                    emailFocusedIconColor = kErrorColor;
                                    pwdFocusedIconColor = kErrorColor;
                                    errorMessage =
                                        'Too many requests.\nPlease try again Later.';
                                    _pwdController.clear();
                                  } else {
                                    setState(() {
                                      errorMessage =
                                          'Unexpected Error Occurred';
                                      _pwdController.clear();
                                    });
                                  }
                                } catch (error) {
                                  setState(() {
                                    errorMessage = 'Unexpected Error Occurred';
                                    _pwdController.clear();
                                  });
                                }
                              }

                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white))
                                : const Text(
                                    'Sign In',
                                    style: kFilledButtonTextStyle,
                                  )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Don’t have an account?',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
