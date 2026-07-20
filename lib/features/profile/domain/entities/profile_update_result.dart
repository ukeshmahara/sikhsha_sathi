class ProfileUpdateResult {
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImage;

  ProfileUpdateResult({
    required this.fullName,
    required this.email,
    this.phone,
    this.profileImage,
  });

  factory ProfileUpdateResult.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResult(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
    );
  }
}