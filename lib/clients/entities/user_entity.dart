import 'package:doneapp/clients/entities/entity_interface.dart';

class UserEntity implements EntityInterface {
  UserEntity(this.id, this.name, this.email, this.password);

  String? id;
  String name;
  String email;
  String password;

  @override
  toObject() => {
        "name": name,
        "email": email,
        "password": password,
      };
}
