import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/entities/entity_interface.dart';

class AppointmentEntity implements EntityInterface {
  AppointmentEntity(
      {this.id,
      required this.startTime,
      required this.endTime,
      required this.date,
      required this.color,
      required this.description,
      required this.userId});

  String? id = "";

  String startTime;

  String endTime;

  Timestamp date;

  String color;

  String description;

  String userId;

  toObject() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'color': color,
      'description': description,
      'userId': userId,
    };
  }
}
