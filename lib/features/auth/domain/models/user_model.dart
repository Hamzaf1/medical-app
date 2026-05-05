enum UserRole { patient, doctor, unknown }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final bool profileComplete;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.role = UserRole.unknown,
    this.profileComplete = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: _parseRole(data['role']),
      profileComplete: data['profileComplete'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role.name,
      'profileComplete': profileComplete,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    UserRole? role,
    bool? profileComplete,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileComplete: profileComplete ?? this.profileComplete,
    );
  }

  static UserRole _parseRole(String? roleStr) {
    if (roleStr == null) return UserRole.unknown;
    switch (roleStr.toLowerCase()) {
      case 'patient':
        return UserRole.patient;
      case 'doctor':
        return UserRole.doctor;
      default:
        return UserRole.unknown;
    }
  }
}
