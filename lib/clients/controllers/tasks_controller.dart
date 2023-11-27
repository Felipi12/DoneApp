import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/controllers/base_controller.dart';
import 'package:doneapp/clients/entities/tasks_entity.dart';

class TasksController extends BaseController {
  TasksController() : super(FirebaseFirestore.instance.collection('Tasks'));

  Future<List<TaskEntity>> getAll() async {
    try {
      QuerySnapshot querySnapshot = await collection.get();
      List<TaskEntity> allTasks = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return TaskEntity(
          id: doc.id,
          done: data['done'],
          desc: data['desc'],
          date: data['date'],
          userId: data['userId'],
          array: data['array'],
        );
      }).toList();
      return allTasks;
    } catch (e) {
      print('Error getting tasks: $e');
      rethrow;
    }
  }

  Future<TaskEntity> getById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await collection.doc(id).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return TaskEntity(
        id: documentSnapshot.id,
        done: data['done'],
        desc: data['desc'],
        date: data['date'],
        userId: data['userId'],
        array: data['array'],
      );
    } catch (e) {
      print('Error getting task: $e');
      rethrow;
    }
  }

  Future<TaskEntity> create(TaskEntity task) async {
    try {
      DocumentReference taskDB = await collection.add(task.toObject());

      DocumentSnapshot documentSnapshot = await taskDB.get();

      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      return TaskEntity(
        id: documentSnapshot.id,
        done: data['done'],
        desc: data['desc'],
        date: data['date'],
        userId: data['userId'],
        array: data['array'],
      );
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<TaskEntity> update(TaskEntity task) async {
    try {
      await collection.doc(task.id).update(task.toObject());

      DocumentSnapshot documentSnapshot = await collection.doc(task.id).get();

      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      return TaskEntity(
        id: documentSnapshot.id,
        done: data['done'],
        desc: data['desc'],
        date: data['date'],
        userId: data['userId'],
        array: data['array'],
      );
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await collection.doc(id).delete();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}


  /*

  Future testTaskSample() async {
  TasksController tasksController = TasksController();

  TaskEntity taskEntity = TaskEntity(
    done: false,
    desc: "Task description",
    date: Timestamp.fromDate(DateTime.now()),
    userId: "user123",
    xray: "Some xray information",
  );

  TaskEntity taskCreated = await tasksController.create(taskEntity);

  taskCreated.desc = "Updated task description";

  TaskEntity taskUpdated = await tasksController.update(taskCreated);

  print(taskUpdated);

  List<TaskEntity> allTasks = await tasksController.getAll();
  print('All tasks: $allTasks');

  TaskEntity taskById =
      await tasksController.getById(taskUpdated.id ?? "");
  print('Task by id: $taskById');

  await tasksController.delete(taskUpdated.id ?? "");
  print('Task deleted');
}

*/