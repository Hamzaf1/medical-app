import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/appointment_model.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../auth/domain/models/user_model.dart';

final appointmentsProvider = StreamProvider<List<AppointmentModel>>((ref) {
  final currentUserState = ref.watch(currentUserProvider);
  final firestore = FirebaseFirestore.instance;

  if (currentUserState.isLoading || currentUserState.value == null) {
    return const Stream.empty();
  }

  final user = currentUserState.value!;
  
  Query query = firestore.collection('appointments');
  
  // Filter based on role
  if (user.role == UserRole.patient) {
    query = query.where('patientId', isEqualTo: user.uid);
  } else if (user.role == UserRole.doctor) {
    query = query.where('doctorId', isEqualTo: user.uid);
  }

  // Order by date
  query = query.orderBy('dateTime', descending: true);

  return query.snapshots().map((snapshot) {
    return snapshot.docs
        .map((doc) => AppointmentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }).handleError((error) {
    print('Error fetching appointments: \$error');
    // For development without Firebase properly configured, return a mock stream
    return _getMockAppointments(user.role);
  });
});

List<AppointmentModel> _getMockAppointments(UserRole role) {
  return [
    AppointmentModel(
      id: 'mock1',
      patientId: 'patient1',
      doctorId: 'doc1',
      doctorName: 'Dr. Sarah Jenkins',
      specialty: 'Cardiologist',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      status: AppointmentStatus.upcoming,
    ),
    AppointmentModel(
      id: 'mock2',
      patientId: 'patient1',
      doctorId: 'doc2',
      doctorName: 'Dr. Michael Chen',
      specialty: 'Dermatologist',
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      status: AppointmentStatus.completed,
    ),
    AppointmentModel(
      id: 'mock3',
      patientId: 'patient1',
      doctorId: 'doc3',
      doctorName: 'Dr. Emily Carter',
      specialty: 'Pediatrician',
      dateTime: DateTime.now().subtract(const Duration(days: 10)),
      status: AppointmentStatus.cancelled,
    ),
  ];
}
