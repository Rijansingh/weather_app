class FavoriteLocation {
  final String id;
  final String userId;
  final String cityName;
  final DateTime timestamp;

  FavoriteLocation({
    required this.id,
    required this.userId,
    required this.cityName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cityName': cityName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory FavoriteLocation.fromMap(String id, Map<String, dynamic> map) {
    return FavoriteLocation(
      id: id,
      userId: map['userId'],
      cityName: map['cityName'],
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}
