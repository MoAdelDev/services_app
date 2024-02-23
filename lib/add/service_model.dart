class ServiceModel {
  final String title;
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final String image;
  final String address;
  final String id;

  ServiceModel({
    required this.title,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.address,
    required this.id,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      image: json['image'],
      address: json['address'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'address': address,
      'id': id,
    };
  }
}
