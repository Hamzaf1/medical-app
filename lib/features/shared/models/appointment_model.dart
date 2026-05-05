enum AppointmentStatus { upcoming, completed, cancelled }

class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String notes;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
    this.status = AppointmentStatus.upcoming,
    this.notes = '',
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> data, String documentId) {
    return AppointmentModel(
      id: documentId,
      patientId: data['patientId'] ?? '',
      doctorId: data['doctorId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      specialty: data['specialty'] ?? '',
      dateTime: data['dateTime'] != null 
          ? DateTime.parse(data['dateTime']) 
          : DateTime.now(),
      status: _parseStatus(data['status']),
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialty': specialty,
      'dateTime': dateTime.toIso8601String(),
      'status': status.name,
      'notes': notes,
    };
  }

  static AppointmentStatus _parseStatus(String? statusStr) {
    if (statusStr == null) return AppointmentStatus.upcoming;
    switch (statusStr.toLowerCase()) {
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'upcoming':
      default:
        return AppointmentStatus.upcoming;
    }
  }
}
