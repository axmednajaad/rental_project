class Booking {
  final int? bookingId;
  final int propertyId;
  final int userId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String? propertyName;
  final String? userName;

  Booking({
    this.bookingId,
    required this.propertyId,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    this.propertyName,
    this.userName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      propertyId: json['property_id'],
      userId: json['user_id'],
      checkInDate: DateTime.parse(json['check_in_date']),
      checkOutDate: DateTime.parse(json['check_out_date']),
      propertyName: json['property_name'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'user_id': userId,
      'check_in_date': checkInDate.toIso8601String().split('T')[0],
      'check_out_date': checkOutDate.toIso8601String().split('T')[0],
    };
  }

  int get durationInDays {
    return checkOutDate.difference(checkInDate).inDays;
  }
}
