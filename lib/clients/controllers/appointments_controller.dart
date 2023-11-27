import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/controllers/base_controller.dart';
import 'package:doneapp/clients/entities/appointment_entity.dart';

/*
Class to manage Appointments in the Database

Future testSample() async {
  AppointmentsController appointmentsController = AppointmentsController();

  AppointmentEntity appointmentEntity = AppointmentEntity(
    startTime: "10h30",
    endTime: "15h30",
    date: Timestamp.fromDate(DateTime.now()),
    color: "#fff",
    description: "test",
    userId: "adas!@#1312312",
  );

  AppointmentEntity appointmentCreated =
      await appointmentsController.create(appointmentEntity);

  appointmentCreated.description = "UPDATED";

  AppointmentEntity appointmentUpdated =
      await appointmentsController.update(appointmentCreated);

  print(appointmentUpdated);

  List<AppointmentEntity> allAppointments =
      await appointmentsController.getAll();
  print('All appointments: $allAppointments');

  AppointmentEntity appointmentById =
      await appointmentsController.getById(appointmentUpdated.id ?? "");
  print('Appointment by id: $appointmentById');

  await appointmentsController.delete(appointmentUpdated.id ?? "");
  print('Appointment deleted');
}
*/
class AppointmentsController extends BaseController {
  AppointmentsController()
      : super(FirebaseFirestore.instance.collection('Appointments'));

  Future<List<AppointmentEntity>> getAll() async {
    try {
      QuerySnapshot querySnapshot = await collection.get();
      List<AppointmentEntity> allAppointments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppointmentEntity(
          id: doc.id,
          startTime: data['startTime'],
          endTime: data['endTime'],
          date: data['date'],
          color: data['color'],
          description: data['description'],
          userId: data['userId'],
        );
      }).toList();
      return allAppointments;
    } catch (e) {
      print('Error getting appointments: $e');
      rethrow;
    }
  }

  Future<AppointmentEntity> getById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await collection.doc(id).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return AppointmentEntity(
        id: documentSnapshot.id,
        startTime: data['startTime'],
        endTime: data['endTime'],
        date: data['date'],
        color: data['color'],
        description: data['description'],
        userId: data['userId'],
      );
    } catch (e) {
      print('Error getting appointment: $e');
      rethrow;
    }
  }

  Future<AppointmentEntity> create(AppointmentEntity appointment) async {
    try {
      DocumentReference appointmentDB =
          await collection.add(appointment.toObject());

      DocumentSnapshot documentSnapshot = await appointmentDB.get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      return AppointmentEntity(
        id: documentSnapshot.id,
        startTime: data['startTime'],
        endTime: data['endTime'],
        date: data['date'],
        color: data['color'],
        description: data['description'],
        userId: data['userId'],
      );
    } catch (e) {
      print('Error creating appointment: $e');
      rethrow;
    }
  }

  Future<AppointmentEntity> update(AppointmentEntity appointment) async {
    try {
      await collection.doc(appointment.id).update(appointment.toObject());

      DocumentSnapshot documentSnapshot =
          await collection.doc(appointment.id).get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      return AppointmentEntity(
        id: documentSnapshot.id,
        startTime: data['startTime'],
        endTime: data['endTime'],
        date: data['date'],
        color: data['color'],
        description: data['description'],
        userId: data['userId'],
      );
    } catch (e) {
      print('Error updating appointment: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await collection.doc(id).delete();
    } catch (e) {
      print('Error deleting appointment: $e');
      rethrow;
    }
  }
}
