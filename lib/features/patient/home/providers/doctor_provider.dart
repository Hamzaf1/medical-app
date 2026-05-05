import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/doctor_model.dart';

final selectedSpecialtyProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

final doctorListProvider = FutureProvider<List<DoctorModel>>((ref) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('doctors').get();
    
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) => DoctorModel.fromMap(doc.data(), doc.id)).toList();
    } else {
      return _getMockDoctors();
    }
  } catch (e) {
    print('Error fetching doctors, returning mock data: \$e');
    return _getMockDoctors();
  }
});

final filteredDoctorsProvider = Provider<List<DoctorModel>>((ref) {
  final doctorsAsync = ref.watch(doctorListProvider);
  final specialty = ref.watch(selectedSpecialtyProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return doctorsAsync.maybeWhen(
    data: (doctors) {
      return doctors.where((doctor) {
        final matchesSpecialty = specialty == null || doctor.specialty == specialty;
        final matchesQuery = doctor.name.toLowerCase().contains(query) ||
            doctor.specialty.toLowerCase().contains(query);
        return matchesSpecialty && matchesQuery;
      }).toList();
    },
    orElse: () => [],
  );
});

List<DoctorModel> _getMockDoctors() {
  return [
    DoctorModel(
      uid: 'doc1',
      name: 'Dr. Sarah Jenkins',
      specialty: 'Cardiologist',
      bio: 'Expert in heart diseases and cardiovascular health.',
      consultationFee: 150.0,
      rating: 4.9,
      city: 'New York',
      profileImageUrl: 'https://via.placeholder.com/150',
      availableSlots: ['09:00 AM', '10:00 AM', '11:00 AM'],
    ),
    DoctorModel(
      uid: 'doc2',
      name: 'Dr. Michael Chen',
      specialty: 'Dermatologist',
      bio: 'Specializes in skin conditions and cosmetic dermatology.',
      consultationFee: 120.0,
      rating: 4.7,
      city: 'San Francisco',
      profileImageUrl: 'https://via.placeholder.com/150',
      availableSlots: ['01:00 PM', '02:00 PM', '03:30 PM'],
    ),
    DoctorModel(
      uid: 'doc3',
      name: 'Dr. Emily Carter',
      specialty: 'Pediatrician',
      bio: 'Compassionate care for children from newborns to teens.',
      consultationFee: 100.0,
      rating: 4.8,
      city: 'Chicago',
      profileImageUrl: 'https://via.placeholder.com/150',
      availableSlots: ['09:00 AM', '01:00 PM'],
    ),
    DoctorModel(
      uid: 'doc4',
      name: 'Dr. Robert Wilson',
      specialty: 'Neurologist',
      bio: 'Advanced treatment for neurological disorders.',
      consultationFee: 200.0,
      rating: 4.9,
      city: 'Boston',
      profileImageUrl: 'https://via.placeholder.com/150',
      availableSlots: ['10:00 AM', '11:00 AM', '02:00 PM', '04:00 PM'],
    ),
  ];
}
