import 'package:aquamate/models/fish_data_model.dart';
import 'package:aquamate/utils/constants.dart';
import 'package:aquamate/widgets/rounded_filled_button.dart';
import 'package:flutter/material.dart';

class FishDetailsScreen extends StatelessWidget {
  const FishDetailsScreen({
    super.key,
    required this.image,
    required this.data,
  });

  final Image image;
  final FishData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'About ${data.fishName}',
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            Align(
              child: SizedBox(
                width: 180,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: image,
                ),
              ),
            ),
            kSizedBoxH30,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.fishName,
                  style: kHeadlineTextStyle,
                ),
                RoundedFilledButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'View Tankmates',
                      style: kFilledButtonTextStyle.copyWith(fontSize: 13),
                    ),
                  ),
                )
              ],
            ),
            kSizedBoxH30,
            FishDataRow(
              title: 'Scientific Name',
              description: data.scientificName,
            ),
            kSizedBoxH10,
            FishDataRow(
              title: 'pH value',
              description: data.ph,
            ),
            kSizedBoxH10,
            FishDataRow(
              title: 'Temperature',
              description: data.temp,
            ),
            kSizedBoxH10,
            FishDataRow(
              title: 'Diet',
              description: data.diet,
            ),
            kSizedBoxH10,
            FishDataRow(
              title: 'Tank size',
              description: data.tankSize,
            ),
            kSizedBoxH20,
            Text(
              data.description,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}

class FishDataRow extends StatelessWidget {
  const FishDataRow({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 120,
            child: Text(
              '$title',
              style: const TextStyle(fontWeight: FontWeight.w600),
            )),
        const Text(":\t\t"),
        Expanded(child: Text(description)),
      ],
    );
  }
}
