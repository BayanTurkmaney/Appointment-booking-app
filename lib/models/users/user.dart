class User {
  String idUser;
  String firstName;
  String lastName;
  String? photo;
  String email;
  String? phone1;
  String? phone2;
  bool? isVerified;
  String type;
  Map address;

  User({
    required this.idUser,
    required this.address,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.photo,
    required this.isVerified,
    required this.phone1,
    this.phone2,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      photo: json['photo'],
      email: json["email"],
      phone1: json["phone1"],
      phone2: json["phone2"],
      isVerified: (json["isVerified"] ?? 'true').toLowerCase() == 'true',
      type: json["type"],
      address: json['address'],
    );
  }
}
