class Property {
  final int? propertyId;
  final String name;
  final String description;
  final String type;
  final String size;
  final String location;
  final double price;

  Property({
    this.propertyId,
    required this.name,
    required this.description,
    required this.type,
    required this.size,
    required this.location,
    required this.price,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    print('Parsing Property from JSON: $json'); // Debug log
    return Property(
      propertyId: json['property_id'] ?? json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      location: json['location'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'size': size,
      'location': location,
      'price': price,
    };
  }
}
