class PatientProfileModel {
  final String patientId;
  final String ageGroup;
  final String bloodType;
  final double weightKg;
  final double heightCm;
  final List<String> chronicConditions;
  final List<String> allergies;

  PatientProfileModel({
    required this.patientId,
    required this.ageGroup,
    required this.bloodType,
    required this.weightKg,
    required this.heightCm,
    required this.chronicConditions,
    required this.allergies,
  });

  factory PatientProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return PatientProfileModel(
      patientId: id,
      ageGroup: map['ageGroup'] ?? 'Unknown',
      bloodType: map['bloodType'] ?? 'Unknown',
      weightKg: (map['weightKg'] ?? 0).toDouble(),
      heightCm: (map['heightCm'] ?? 0).toDouble(),
      chronicConditions: List<String>.from(map['chronicConditions'] ?? []),
      allergies: List<String>.from(map['allergies'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ageGroup': ageGroup,
      'bloodType': bloodType,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'chronicConditions': chronicConditions,
      'allergies': allergies,
    };
  }

  // Helper method to get an anonymized summary for AI
  String getAnonymizedSummary() {
    return '''
Patient Profile:
- Age Group: $ageGroup
- Blood Type: $bloodType
- Weight: ${weightKg}kg
- Height: ${heightCm}cm
- Chronic Conditions: ${chronicConditions.join(', ')}
- Allergies: ${allergies.join(', ')}
''';
  }
}
