class Employee {
  String institutionId;
  String id;
  String firstName;
  String lastName;
  String? photo;
  String email;
  String? speciality;
  String password;
  double rating;

  Employee({
    required this.institutionId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.photo,
    required this.rating,
    required this.speciality,
    required this.id,
  });
}
