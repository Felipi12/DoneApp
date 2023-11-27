import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/controllers/base_controller.dart';
import 'package:doneapp/clients/entities/user_entity.dart';

class UserController extends BaseController {
  UserController() : super(FirebaseFirestore.instance.collection('Users'));

  Future<List<UserEntity>> getAll() async {
    try {
      QuerySnapshot querySnapshot = await collection.get();
      List<UserEntity> allUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserEntity(
          id: doc.id,
          user: data['user'],
          pssw: data['pssw'],
          imgAvatar: data['imgAvatar'],
          idade: data['idade'],
          countAppoints: data['countAppoints'],
          countTasks: data['countTasks'],
        );
      }).toList();
      return allUsers;
    } catch (e) {
      print('Error getting users: $e');
      rethrow;
    }
  }

  Future<UserEntity> getById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await collection.doc(id).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return UserEntity(
        id: documentSnapshot.id,
        user: data['user'],
        pssw: data['pssw'],
        imgAvatar: data['imgAvatar'],
        idade: data['idade'],
        countAppoints: data['countAppoints'],
        countTasks: data['countTasks'],
      );
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<UserEntity> create(UserEntity user) async {
    try {
      DocumentReference userDB = await collection.add(user.toObject());

      DocumentSnapshot documentSnapshot = await userDB.get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      return UserEntity(
        id: documentSnapshot.id,
        user: data['user'],
        pssw: data['pssw'],
        imgAvatar: data['imgAvatar'],
        idade: data['idade'],
        countAppoints: data['countAppoints'],
        countTasks: data['countTasks'],
      );
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<UserEntity> update(UserEntity user) async {
    try {
      await collection.doc(user.id!).update(user.toObject());

      DocumentSnapshot documentSnapshot = await collection.doc(user.id!).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      return UserEntity(
        id: documentSnapshot.id,
        user: data['user'],
        pssw: data['pssw'],
        imgAvatar: data['imgAvatar'],
        idade: data['idade'],
        countAppoints: data['countAppoints'],
        countTasks: data['countTasks'],
      );
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await collection.doc(id).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}

class UserEntity {
  final String id;
  final String user;
  final String pssw;
  final String imgAvatar;
  final int idade;
  final int countAppoints; // ou countTasks
  final int countTasks;

  UserEntity({
    required this.id,
    required this.user,
    required this.pssw,
    required this.imgAvatar,
    required this.idade,
    required this.countAppoints,
    required this.countTasks,
  });

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
