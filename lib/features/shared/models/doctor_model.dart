class DoctorModel {
  final String uid;
  final String name;
  final String specialty;
  final String bio;
  final double consultationFee;
  final double rating;
  final String city;
  final String profileImageUrl;
  final List<String> availableSlots;

  DoctorModel({
    required this.uid,
    required this.name,
    required this.specialty,
    required this.bio,
    required this.consultationFee,
    required this.rating,
    required this.city,
    required this.profileImageUrl,
    required this.availableSlots,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> data, String documentId) {
    return DoctorModel(
      uid: documentId,
      name: data['name'] ?? '',
      specialty: data['specialty'] ?? '',
      bio: data['bio'] ?? '',
      consultationFee: (data['consultationFee'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      city: data['city'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      availableSlots: List<String>.from(data['availableSlots'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'bio': bio,
      'consultationFee': consultationFee,
      'rating': rating,
      'city': city,
      'profileImageUrl': profileImageUrl,
      'availableSlots': availableSlots,
    };
  }
}
