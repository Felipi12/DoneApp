import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/entities/entity_interface.dart';

class TaskEntity implements EntityInterface {
  TaskEntity({
    required this.id,
    required this.done,
    required this.desc,
    required this.date,
    required this.userId,
    required this.array,
  });

  String id = "";
  bool done;
  String desc;
  Timestamp date;
  String userId;
  String array;

  Map<String, dynamic> toObject() {
    return {
      'done': done,
      'desc': desc,
      'date': date,
      'userId': userId,
      'array': array,
    };
  }
}
