import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/entities/entity_interface.dart';

class UserEntity implements EntityInterface {
  UserEntity({
    required this.id,
    required this.user,
    required this.pssw,
    required this.imgAvatar,
    required this.idade,
    required this.countAppoints,
    required this.countTasks,
  });

  String id;
  String user;
  String pssw;
  String imgAvatar;
  int idade;
  int countAppoints;
  int countTasks;

  Map<String, dynamic> toObject() {
    return {
      'user': user,
      'pssw': pssw,
      'imgAvatar': imgAvatar,
      'idade': idade,
      'countAppoints': countAppoints,
      'countTasks': countTasks,
    };
  }
}
