import 'package:aquamate/utils/constants.dart';
import 'package:aquamate/widgets/round_icon_button.dart';
import 'package:aquamate/widgets/rounded_filled_button.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManageTankScreen extends StatefulWidget {
  const ManageTankScreen({super.key});

  @override
  State<ManageTankScreen> createState() => _ManageTankScreenState();
}

class _ManageTankScreenState extends State<ManageTankScreen> {
  final fishBreedsList = ['Goldfish', 'Arowana', 'Oscar', 'Angelfish'];
  final tankSizeList = [
    '10 liters',
    '15 liters',
    '20 liters',
    '25 liters',
    '30 liters'
  ];
  DateTime? scheduledDate;
  String? fishBreedDropDownValue;
  String? tankSizeDropDownValue;
  int fishCount = 0;
  String date = 'No Date Selected';
  User? user;
  late DatabaseReference tankDetailsRef;

  bool isDataEmpty() =>
      fishBreedDropDownValue == null ||
      tankSizeDropDownValue == null ||
      fishCount == 0 ||
      date == 'No Date Selected';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    tankDetailsRef = FirebaseDatabase.instance.ref('tanksDetails/${user!.uid}');

    tankDetailsRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final tankData = event.snapshot.value as Map;
        setState(() {
          fishCount = tankData['fishCount'];
          date = tankData['date'];
          fishBreedDropDownValue = tankData['breed'];
          tankSizeDropDownValue = tankData['tankSize'];
          scheduledDate = DateTime.parse(date);
        });
      } else {
        setState(() {
          fishCount = 0;
          date = 'No Date Selected';
          fishBreedDropDownValue = null;
          tankSizeDropDownValue = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Tank Details',
          textAlign: TextAlign.center,
          style: kHeadlineTextStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Visibility(
            visible: !isDataEmpty(),
            child: TextButton(
              onPressed: () async {
                await tankDetailsRef.remove();
              },
              child: const Text(
                'DELETE',
                style: TextStyle(color: Color(0xFFCC5858)),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161D1F),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  'Select Fish',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                value: fishBreedDropDownValue,
                                items: fishBreedsList
                                    .map(
                                      (String item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    fishBreedDropDownValue = value!;
                                  });
                                },
                                dropdownStyleData: DropdownStyleData(
                                  elevation: 0,
                                  maxHeight: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: const Color(0xFF131719),
                                    boxShadow: const [],
                                  ),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          kPrimaryThemeColor.withOpacity(0.3),
                                    ),
                                    color: const Color(0x500a1117),
                                  ),
                                  height: 50,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    child: Icon(
                                      FontAwesomeIcons.chevronDown,
                                      size: 15,
                                    ),
                                  ),
                                  iconEnabledColor: Colors.grey.shade700,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 48,
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  'Select Tank Size',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                value: tankSizeDropDownValue,
                                items: tankSizeList
                                    .map(
                                      (String item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    tankSizeDropDownValue = value!;
                                  });
                                },
                                dropdownStyleData: DropdownStyleData(
                                  elevation: 0,
                                  maxHeight: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: const Color(0xFF131719),
                                    boxShadow: const [],
                                  ),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          kPrimaryThemeColor.withOpacity(0.3),
                                    ),
                                    color: const Color(0x500a1117),
                                  ),
                                  height: 50,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    child: Icon(
                                      FontAwesomeIcons.chevronDown,
                                      size: 15,
                                    ),
                                  ),
                                  iconEnabledColor: Colors.grey.shade700,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 48,
                                ),
                              ),
                            ),
                          ],
                        ),
                        kSizedBoxH30,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'NO OF FISH',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: <Widget>[
                                      Text(
                                        fishCount.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3.0,
                                      ),
                                    ],
                                  ),
                                  kSizedBoxH10,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RoundedIconButton(
                                        icon: FontAwesomeIcons.minus,
                                        onPress: () {
                                          setState(() {
                                            if (fishCount > 1) {
                                              fishCount--;
                                            }
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      RoundedIconButton(
                                        icon: FontAwesomeIcons.plus,
                                        onPress: () {
                                          setState(() {
                                            fishCount++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'LAST DAY CLEANED',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                kSizedBoxH10,
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  fillColor: const Color(0xFF31343D),
                                  splashColor:
                                      kPrimaryThemeColor.withOpacity(0.15),
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(DateTime.now().year),
                                      lastDate:
                                          DateTime(DateTime.now().year + 1),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            // override MaterialApp ThemeData
                                            colorScheme: const ColorScheme.dark(
                                              primary:
                                                  kPrimaryThemeColor, //header and selced day background color
                                              onPrimary:
                                                  Colors.white, // titles and
                                              onSurface: Colors
                                                  .white, // Month days , years
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors
                                                    .white, // ok , cancel    buttons
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    ).then((value) {
                                      setState(() {
                                        scheduledDate = value;
                                        date =
                                            value.toString().substring(0, 10);
                                      });
                                    });
                                  },
                                  child: const Text('Pick date'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  kSizedBoxH30,
                  SizedBox(
                    width: 325,
                    child: Text(
                      'Info:\nSaving tank details will allow us to remind about cleaning of the tank for you. Please make sure to fill the all fields before saving the tank details.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: RoundedFilledButton(
                  onPressed: () async {
                    if (isDataEmpty()) {
                      final snackBar = SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                          bottom: 10,
                          right: 10,
                          left: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: const Color(0xFFAF4842),
                        content: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Colors.white,
                            ),
                            kSizedBoxW10,
                            Text(
                              'All values should be filled',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    var data = {
                      "breed": fishBreedDropDownValue,
                      "fishCount": fishCount,
                      "tankSize": tankSizeDropDownValue,
                      "date": date,
                    };

                    final user = FirebaseAuth.instance.currentUser;

                    final tankDetailsRef = FirebaseDatabase.instance
                        .ref('tanksDetails/${user!.uid}');

                    await tankDetailsRef.set(data);

                    AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 1,
                        channelKey: 'basic_channel',
                        title: 'Hello Aquamate',
                        body: 'It\'s time to clean your tank',
                        actionType: ActionType.KeepOnTop,
                      ),
                      schedule: NotificationCalendar(
                        year: scheduledDate!.year,
                        month: scheduledDate!.month,
                        day: scheduledDate!.day,
                        hour: 8,
                        minute: 0,
                        second: 0,
                        millisecond: 0,
                        timeZone: 'Asia/Colombo',
                        allowWhileIdle: true,
                        repeats: true,
                      ),
                    );
                  },
                  child: Text(
                    '${isDataEmpty() ? 'Save' : 'Update'} Tank Details',
                    style: kFilledButtonTextStyle,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
