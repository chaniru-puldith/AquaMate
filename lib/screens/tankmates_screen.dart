import 'package:aquamate/utils/constants.dart';
import 'package:flutter/material.dart';

class TankmatesScreen extends StatelessWidget {
  const TankmatesScreen({super.key, required this.tankmates});

  final List tankmates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tankmates',
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
        child: tankmates.isNotEmpty
            ? Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                height: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: List.generate(
                    tankmates.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 160,
                          height: 210,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.black, Color(0xFF101010)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Align(
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.asset(tankmates[index]['image']),
                                ),
                              ),
                              kSizedBoxH30,
                              kSizedBoxH10,
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF1F1F1),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Text(
                                    tankmates[index]['name'],
                                    style: const TextStyle(color: Colors.black),
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : const Center(
                child: Text('Better to keep alone'),
              ),
      ),
    );
  }
}
