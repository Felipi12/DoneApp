import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/entities/entity_interface.dart';

class AppointmentEntity implements EntityInterface {
  AppointmentEntity(
      {this.id,
      required this.startTime,
      required this.endTime,
      required this.color,
      required this.description,
      this.userId = ""});

  String? id = "";

  Timestamp startTime;

  Timestamp endTime;

  String color;

  String description;

  String userId;

  @override
  toObject() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'description': description,
      'userId': userId,
    };
  }
}
