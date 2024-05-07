import 'package:aquamate/utils/constants.dart';
import 'package:aquamate/widgets/rounded_filled_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance;
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool passwordToggle = false;
  bool confirmPasswordToggle = false;
  String password = '';
  String confirmPassword = '';
  String email = '';
  String name = '';
  bool isPasswordMatching = true;
  bool isLoading = false;
  bool isNameTapped = false;
  bool isEmailTapped = false;
  bool isPwdTapped = false;
  bool isConfirmPwdTapped = false;
  String errorMessage = '';
  Color pwdFocusedIconColor = kPrimaryThemeColor;
  Color confirmPwdFocusedIconColor = kPrimaryThemeColor;
  Color emailFocusedIconColor = kPrimaryThemeColor;
  Color nameFoucsedIconColor = kPrimaryThemeColor;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    RegExp sixCharactersRegex = RegExp(r'^.{6,}$');
    RegExp uppercaseRegex = RegExp(r'[A-Z]');
    RegExp lowercaseRegex = RegExp(r'[a-z]');
    RegExp specialCharacterRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    RegExp numberRegex = RegExp(r'[0-9]');

    bool hasSixCharacters = sixCharactersRegex.hasMatch(password);
    bool hasUppercase = uppercaseRegex.hasMatch(password);
    bool hasLowercase = lowercaseRegex.hasMatch(password);
    bool hasSpecialCharacter = specialCharacterRegex.hasMatch(password);
    bool hasNumber = numberRegex.hasMatch(password);

    return hasSixCharacters &&
        hasUppercase &&
        hasLowercase &&
        hasSpecialCharacter &&
        hasNumber;
  }

  String _validateInputs() {
    if (name.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      setState(() {
        isPwdTapped = false;
        isConfirmPwdTapped = false;
        isEmailTapped = false;
        isNameTapped = false;
        nameFoucsedIconColor = kErrorColor;
        emailFocusedIconColor = kErrorColor;
        pwdFocusedIconColor = kErrorColor;
        confirmPwdFocusedIconColor = kErrorColor;
      });
      return "Please enter name, email, password and confirm password";
    } else if (name.isEmpty) {
      setState(() {
        isNameTapped = false;
        nameFoucsedIconColor = kErrorColor;
      });
      return "Please enter your name";
    } else if (email.isEmpty) {
      setState(() {
        isEmailTapped = false;
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
    } else if (!_isValidPassword(password)) {
      setState(() {
        isPwdTapped = false;
        pwdFocusedIconColor = kErrorColor;
      });
      return "Password must have at least  6 characters,\n at least one uppercase and one lowercase letter,\n at least one special character,\n at lease one number.";
    } else if (confirmPassword.isEmpty) {
      setState(() {
        isConfirmPwdTapped = false;
        confirmPwdFocusedIconColor = kErrorColor;
      });
      return "Please enter confirm password";
    } else if (confirmPassword != password) {
      setState(() {
        isPwdTapped = false;
        isConfirmPwdTapped = false;
        pwdFocusedIconColor = kErrorColor;
        confirmPwdFocusedIconColor = kErrorColor;
      });
      return "Password and confirm password don't match";
    } else {
      return "";
    }
  }

  void _showSignupSuccessDialog(BuildContext context) {
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
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: kPoppinsHeadlineStyle.copyWith(fontSize: 19),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                      'You have successfully registered into the AQUAMATE. Sign in to continue.',
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
          "Sign Up",
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
                      'Create a new account using name, email and password',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    height: 57,
                    child: TextField(
                      controller: _nameController,
                      focusNode: _focusNodes[0],
                      style: kPoppinsRegularTextStyle,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kTextFieldFillColor,
                        hintText: 'Enter Your Name',
                        hintStyle: kPoppinsHintTextStyle,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.account_box_outlined,
                            color: errorMessage
                                        .toLowerCase()
                                        .contains('name') ||
                                    errorMessage
                                            .toLowerCase()
                                            .contains('already registred') &&
                                        !isNameTapped
                                ? kErrorColor
                                : _focusNodes[0].hasFocus
                                    ? nameFoucsedIconColor
                                    : kTextFieldUtilsColor,
                          ),
                        ),
                        enabledBorder:
                            errorMessage.toLowerCase().contains('name') ||
                                    errorMessage
                                            .toLowerCase()
                                            .contains('already registred') &&
                                        !isNameTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                        focusedBorder:
                            errorMessage.toLowerCase().contains('name') ||
                                    errorMessage
                                            .toLowerCase()
                                            .contains('already registred') &&
                                        !isNameTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                        border: errorMessage.toLowerCase().contains('name') ||
                                errorMessage
                                        .toLowerCase()
                                        .contains('already registred') &&
                                    !isNameTapped
                            ? kTextFeildErrorOutlineBorder
                            : kTextFieldOutlineBorder,
                      ),
                      onTap: () {
                        setState(() {
                          isNameTapped = true;
                          nameFoucsedIconColor = kPrimaryThemeColor;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                  kSizedBoxH10,
                  SizedBox(
                    height: 57,
                    child: TextField(
                      controller: _emailController,
                      focusNode: _focusNodes[1],
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
                            color: errorMessage
                                        .toLowerCase()
                                        .contains('email') ||
                                    errorMessage
                                            .toLowerCase()
                                            .contains('already registred') &&
                                        !isEmailTapped
                                ? kErrorColor
                                : _focusNodes[1].hasFocus
                                    ? emailFocusedIconColor
                                    : kTextFieldUtilsColor,
                          ),
                        ),
                        enabledBorder:
                            errorMessage.toLowerCase().contains('email') ||
                                    errorMessage
                                            .toLowerCase()
                                            .contains('already registred') &&
                                        !isEmailTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                        focusedBorder:
                            errorMessage.toLowerCase().contains('email') ||
                                    errorMessage
                                            .toLowerCase()
                                            .contains('already registred') &&
                                        !isEmailTapped
                                ? kTextFeildErrorOutlineBorder
                                : kTextFieldOutlineBorder,
                        border: errorMessage.toLowerCase().contains('email') ||
                                errorMessage
                                        .toLowerCase()
                                        .contains('already registred') &&
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
                      focusNode: _focusNodes[2],
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
                                        .contains('password') ||
                                    errorMessage
                                            .toLowerCase()
                                            .contains('already registred') &&
                                        (errorMessage.toLowerCase().contains(
                                                'password and confirm') ||
                                            !errorMessage
                                                .toLowerCase()
                                                .contains('confirm')) &&
                                        !isPwdTapped
                                ? kErrorColor
                                : _focusNodes[2].hasFocus
                                    ? pwdFocusedIconColor
                                    : kTextFieldUtilsColor,
                          ),
                        ),
                        enabledBorder: errorMessage
                                    .toLowerCase()
                                    .contains('password') ||
                                errorMessage
                                        .toLowerCase()
                                        .contains('already registred') &&
                                    (errorMessage
                                            .toLowerCase()
                                            .contains('password and confirm') ||
                                        !errorMessage
                                            .toLowerCase()
                                            .contains('confirm')) &&
                                    !isPwdTapped
                            ? kTextFeildErrorOutlineBorder
                            : kTextFieldOutlineBorder,
                        focusedBorder: errorMessage
                                    .toLowerCase()
                                    .contains('password') ||
                                errorMessage
                                        .toLowerCase()
                                        .contains('already registred') &&
                                    (errorMessage
                                            .toLowerCase()
                                            .contains('password and confirm') ||
                                        !errorMessage
                                            .toLowerCase()
                                            .contains('confirm')) &&
                                    !isPwdTapped
                            ? kTextFeildErrorOutlineBorder
                            : kTextFieldOutlineBorder,
                        border: errorMessage
                                    .toLowerCase()
                                    .contains('password') ||
                                errorMessage
                                        .toLowerCase()
                                        .contains('already registred') &&
                                    (errorMessage
                                            .toLowerCase()
                                            .contains('password and confirm') ||
                                        !errorMessage
                                            .toLowerCase()
                                            .contains('confirm')) &&
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
                  kSizedBoxH10,
                  SizedBox(
                    height: 57,
                    child: TextField(
                      focusNode: _focusNodes[3],
                      style: kPoppinsRegularTextStyle,
                      obscureText: !confirmPasswordToggle,
                      controller: _confirmPwdController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kTextFieldFillColor,
                        hintText: 'Confirm Your Password',
                        hintStyle: kPoppinsHintTextStyle,
                        suffixIcon: IconButton(
                          icon: Icon(
                            confirmPasswordToggle
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: confirmPasswordToggle
                                ? kPrimaryThemeColor
                                : kTextFieldUtilsColor,
                          ),
                          onPressed: () {
                            setState(() {
                              confirmPasswordToggle = !confirmPasswordToggle;
                            });
                          },
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: errorMessage
                                        .toLowerCase()
                                        .contains('confirm password') ||
                                    errorMessage
                                            .toLowerCase()
                                            .contains('already registred') &&
                                        !isConfirmPwdTapped
                                ? kErrorColor
                                : _focusNodes[3].hasFocus
                                    ? confirmPwdFocusedIconColor
                                    : kTextFieldUtilsColor,
                          ),
                        ),
                        enabledBorder: errorMessage
                                    .toLowerCase()
                                    .contains('confirm password') ||
                                errorMessage
                                        .toLowerCase()
                                        .contains('already registred') &&
                                    !isConfirmPwdTapped
                            ? kTextFeildErrorOutlineBorder
                            : kTextFieldOutlineBorder,
                        focusedBorder: errorMessage
                                    .toLowerCase()
                                    .contains('confirm password') ||
                                errorMessage
                                        .toLowerCase()
                                        .contains('already registred') &&
                                    !isConfirmPwdTapped
                            ? kTextFeildErrorOutlineBorder
                            : kTextFieldOutlineBorder,
                        border: errorMessage
                                    .toLowerCase()
                                    .contains('confirm password') ||
                                errorMessage
                                        .toLowerCase()
                                        .contains('already registred') &&
                                    !isConfirmPwdTapped
                            ? kTextFeildErrorOutlineBorder
                            : kTextFieldOutlineBorder,
                      ),
                      onTap: () {
                        setState(() {
                          isConfirmPwdTapped = true;
                          confirmPwdFocusedIconColor = kPrimaryThemeColor;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
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
                                isConfirmPwdTapped = false;
                                isNameTapped = false;
                                isLoading = true;
                                errorMessage = '';
                                nameFoucsedIconColor = kPrimaryThemeColor;
                                confirmPwdFocusedIconColor = kPrimaryThemeColor;
                                pwdFocusedIconColor = kPrimaryThemeColor;
                                emailFocusedIconColor = kPrimaryThemeColor;
                              });

                              errorMessage = _validateInputs();

                              if (errorMessage.isEmpty) {
                                try {
                                  await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password)
                                      .timeout(const Duration(seconds: 5));
                                  _pwdController.clear();
                                  _confirmPwdController.clear();
                                  password = '';
                                  confirmPassword = '';
                                  await _database
                                      .ref('users/${_auth.currentUser!.uid}')
                                      .set({'name': name, 'email': email});

                                  if (!mounted) return;

                                  _showSignupSuccessDialog(context);
                                  await _auth.signOut();

                                  await Future.delayed(Duration(seconds: 3));

                                  if (!mounted) return;

                                  Navigator.pushReplacementNamed(
                                      context, '/signin');
                                } on FirebaseAuthException catch (authError) {
                                  if (authError.code ==
                                      'email-already-in-use') {
                                    setState(() {
                                      nameFoucsedIconColor = kErrorColor;
                                      emailFocusedIconColor = kErrorColor;
                                      pwdFocusedIconColor = kErrorColor;
                                      confirmPwdFocusedIconColor = kErrorColor;
                                      errorMessage =
                                          'This email is already registred,\n  Try Signing in.';
                                      _pwdController.clear();
                                      _confirmPwdController.clear();
                                      password = '';
                                      confirmPassword = '';
                                    });
                                  }
                                  print("AuthError: ${authError.code}");
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
                                    'Sign Up',
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
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 13,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
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
