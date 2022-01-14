import 'package:booking_app/models/users/user.dart';

class Owner extends User {
  final bool hasInstitution;

  Owner({
    required idUser,
    required address,
    required email,
    required firstName,
    required lastName,
    required type,
    required photo,
    required isVerified,
    required phone1,
    required this.hasInstitution,
    phone2,
  }) : super(
          photo: photo,
          phone1: phone1,
          lastName: lastName,
          isVerified: isVerified,
          idUser: idUser,
          firstName: firstName,
          email: email,
          address: address,
          type: type,
          phone2: phone2,
        );
}
