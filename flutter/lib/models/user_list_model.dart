class Users {
  final String id;
  final String name;
  final String number;
  final String? profileImage;
  final String? uid;

  Users({
    required this.id,
    required this.name,
    required this.number,
    required this.profileImage,
    required this.uid
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      number: json['phoneNumber'],
      profileImage: json['profileImageUrl'],
      uid: json['id']
    );
  }
}
