class UserModel {
  final String id;
  final String phone;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? maritalStatus;
  final String email;
  final bool emailVerified;
  final String panNumber;
  final bool panVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.phone,
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.email = '',
    this.emailVerified = false,
    this.panNumber = '',
    this.panVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'User' : name;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
      gender: json['gender']?.toString(),
      maritalStatus: json['maritalStatus']?.toString(),
      email: json['email']?.toString() ?? '',
      emailVerified: json['emailVerified'] == true,
      panNumber: json['panNumber']?.toString() ?? '',
      panVerified: json['panVerified'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'maritalStatus': maritalStatus,
      'email': email,
      'emailVerified': emailVerified,
      'panNumber': panNumber,
      'panVerified': panVerified,
    };
  }
}
