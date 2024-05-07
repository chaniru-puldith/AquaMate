class FishData {
  final String fishName;
  final String scientificName;
  final String ph;
  final String temp;
  final String diet;
  final String tankSize;
  final String description;
  final String image;
  final List tankMates;

  FishData(
      {required fishName,
      required scientificName,
      required ph,
      required temp,
      required diet,
      required tankSize,
      required description,
      required image,
      required tankMates})
      : fishName = fishName ?? '',
        scientificName = scientificName ?? '',
        ph = ph ?? '',
        temp = temp ?? '',
        diet = diet ?? '',
        tankSize = tankSize ?? '',
        description = description ?? '',
        image = image ?? '',
        tankMates = tankMates ?? [];

  factory FishData.fromJson(Map<dynamic, dynamic> json) {
    final fishData = FishData(
      fishName: json['fishName'],
      scientificName: json['scientificName'],
      ph: json['ph'],
      temp: json['temp'],
      diet: json['diet'],
      tankSize: json['tankSize'],
      description: json['description'],
      image: json['image'],
      tankMates: json['tankMates'],
    );
    return fishData;
  }
}
