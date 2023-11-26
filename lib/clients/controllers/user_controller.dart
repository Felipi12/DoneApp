import 'package:doneapp/clients/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

//UserEntity userEntity =
//                    UserEntity("Admin 3", "done3@email.com", "Admin12345#");
//                await UserController.create(userEntity: userEntity);
class UserController {
  static Future<UserEntity> create({
    required UserEntity userEntity,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userEntity.email,
        password: userEntity.password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(userEntity.name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return UserEntity(
        user?.uid, user?.displayName ?? "", user?.email ?? "", "");
  }
}
