import 'package:flutter/material.dart';

// Enums
enum TextFieldTypes { password, email }

enum SnackBarType { error, success }

// Colors
const kPrimaryColor = Color(0xFFF5F5F5);
const kSecondaryColor = Color(0xFFF5F5F9);
const kPrimaryThemeColor = Color(0xFF42A5F5);
const kErrorColor = Color(0xFFFF5C5C);
const kTextFieldUtilsColor = Color(0xFF484B4F);
const kTextFieldFillColor = Color(0x0564B5F6);
const kWelcomeDescriptionTextColor = Color(0xFF717784);
const kSecondaryTextColor = Color(0xFFA1A8B0);
const kSuccessColor = Color(0xFF76D3AC);
const kBarrierColor = Color(0x90000000);

// Text Styles
const kPoppinsRegularTextStyle = TextStyle(
  fontSize: 16.0,
);
const kPoppinsBoldTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
);

const kPoppinsHintTextStyle = TextStyle(
  color: kTextFieldUtilsColor,
  fontWeight: FontWeight.w400,
  fontSize: 15.0,
);

const kPoppinsErrorTextStyle = TextStyle(
  color: Color(0xFFFF5C5C),
  fontSize: 11.0,
  fontWeight: FontWeight.w500,
);

const kPoppinsWelcomeDescriptionStyle = TextStyle(
  color: kWelcomeDescriptionTextColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w400,
);

const kPoppinsHeadlineStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w900,
);

const kHeadlineTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

const kFilledButtonTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const kOutlinedButtonTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  color: kPrimaryThemeColor,
);

// Input Boarders
final kTextFieldOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15.0),
  borderSide: const BorderSide(
    color: kPrimaryThemeColor,
    width: 1.5,
  ),
);

final kTextFieldDarkOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15.0),
  borderSide: const BorderSide(
    color: Color.fromARGB(255, 123, 39, 39),
    width: 1.5,
  ),
);

final kTextFeildErrorOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15.0),
  borderSide: const BorderSide(
    color: kErrorColor,
    width: 1.5,
  ),
);

// Sized Boxes
const kSizedBoxH10 = SizedBox(height: 10);
const kSizedBoxH20 = SizedBox(height: 20);
const kSizedBoxH30 = SizedBox(height: 30);
const kSizedBoxW10 = SizedBox(width: 10);
const kSizedBoxW20 = SizedBox(width: 20);
const kSizedBoxW30 = SizedBox(width: 30);

// jsons
const arowanaJson = {
  'fishName': 'Arowana Fish',
  'scientificName': 'Osteoglossinae',
  'ph': 'pH 6.0-6.8',
  'temp': '75-82°F (24-28°C)',
  'diet': 'Insects, crustaceans and small fish',
  'tankSize': 'At least 200 gallons (757 liters) for a single fish',
  'description':
      'Arowanas, also known as dragon fish, are a species of fish that are part of the ancient family of osteoglossidae. They inhabit the inland waters of South America, Southeast Asia, and Australia. Arowanas have elongated bodies covered with large scales and a distinct pair of barbells protruding from the tip of their lower jaw. They are highly predatory fish that you\'ll often see elegantly patrolling the surface of the water.\n\nArowanas can live over twenty years in captivity. They can grow up to 3 feet in length in their natural environment. The most common types of arowana kept in aquariums include the Silver Arowana and the Black Arowana.\n\nRemember, keeping an arowana is a long-term commitment. They require optimal care to flourish, including a suitable tank setup and a specific diet. They are not recommended for beginners due to their care requirements. But with proper care and attention, they can be a fascinating addition to your aquarium. Enjoy your journey into the world of Arowanas! 🐠',
  'image': 'assets/images/arowana.png',
  'tankMates': [
    {'name': 'Peacock Bass', 'image': 'assets/images/peacock_bass.png'},
    {
      'name': 'Bristlenose Plecos',
      'image': 'assets/images/bristlenose_plecos.png'
    },
    {'name': 'Tinfoil Barbs', 'image': 'assets/images/tinfoil_barbs.png'},
    {'name': 'Silver Dollars', 'image': 'assets/images/silver_dollars.png'},
  ]
};

const angleJson = {
  'fishName': 'Angelfish',
  'scientificName': 'Pterophyllum',
  'ph': 'pH 6.0-6.8',
  'temp': '75-80°F (24-27°C)',
  'diet': 'Flakes, pellets, brine shrimp, and bloodworms',
  'tankSize': 'At least 55 gallons (208 liters) for a group of 5-6 fish',
  'description':
      'Angelfish are unique, laterally compressed fish with a diamond-like shape due to their outward-pointing fins. Their vibrant scales flash hues of various colors, and they often have stripes for camouflage. Measuring about six inches long and eight inches tall, they are omnivorous, feeding on small invertebrates, algae, and other tiny creatures. Native to the fresh waters of tropical South America, they inhabit slow-moving water bodies with dense vegetation. Some species are saltwater dwellers. Angelfish are popular pets in home aquariums. Their distinctive shape and vibrant colors make them a favorite among aquarists. 🐠',
  'image': 'assets/images/angel.png',
  'tankMates': [
    {'name': 'Larger Tetras', 'image': 'assets/images/tetra.png'},
    {'name': 'Gouramis', 'image': 'assets/images/gourami.png'},
    {
      'name': 'Corydoras Catfish',
      'image': 'assets/images/corydoras_catfish.png'
    },
    {
      'name': 'Bristlenose Plecos',
      'image': 'assets/images/bristlenose_plecos.png'
    },
  ]
};

const goldFishJson = {
  'fishName': 'Goldfish',
  'scientificName': 'Carassius auratus',
  'ph': 'pH 6.5-7.5',
  'temp': '68-72°F (20-22°C)',
  'diet':
      'Flakes, pellets, algae wafers and occasional treats like brine shrimp or bloodworms',
  'tankSize':
      'Minimum of 20 gallons (75 liters) is recommended for a single goldfish',
  'description':
      'Goldfish, or Carassius auratus, are domestic fish known for their vibrant colors and patterns. Originating from East Asia, they were domesticated nearly 2,000 years ago as ornamental fish. Their body shapes and colors vary greatly, with some being just a few inches long, while others can grow over a foot. As omnivores, they feed on small invertebrates and algae. Goldfish are one of the most popular aquarium fish and are commonly kept as pets in indoor aquariums. Their bright colors and easy care make them a favorite among aquarists. 🐠',
  'image': 'assets/images/goldfish.png',
  'tankMates': [
    {'name': 'Rosy Barbs', 'image': 'assets/images/rosy_barb.png'},
    {
      'name': 'Mountain Minnows',
      'image': 'assets/images/white_cloud_mountain_minnows.png'
    },
    {
      'name': 'Bristlenose Plecos',
      'image': 'assets/images/bristlenose_plecos.png'
    },
    {
      'name': 'Hillstream Loaches',
      'image': 'assets/images/hillstream_loaches.png'
    },
  ]
};

const oscarJson = {
  'fishName': 'Oscar Fish',
  'scientificName': 'Astronotus ocellatus',
  'ph': 'pH 6.0-7.0',
  'temp': '75-80°F (24-27°C)',
  'diet':
      'Require a meaty diet of high-quality pellets, bloodworms, brine shrimp, and occasional feeder fish',
  'tankSize':
      'Minimum of 75 gallons (284 liters) is recommended for a single goldfish',
  'description':
      'Oscar fish, or Astronotus ocellatus, are a species of cichlid native to tropical South America. They are known for their large size, growing up to 45 cm in length and 1.6 kg in weight. Oscars have grey or dark brown scales with yellow and orange spots in the wild, but breeders have developed various colors for home aquariums. As omnivores, they feed on both plant and animal matter. Despite their aggressive behavior, oscars are popular aquarium fish due to their vibrant colors and unique behavior. 🐠',
  'image': 'assets/images/oscar.png',
  'tankMates': []
};
