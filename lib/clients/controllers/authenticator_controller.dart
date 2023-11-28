import 'package:doneapp/clients/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

//await AuthenticatorController.signIn(
//email: userEntity.email, password: userEntity.password);
//print(AuthenticatorController.getLoggedUser());
//AuthenticatorController.singOut();
class AuthenticatorController {
  static Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else {
        rethrow;
      }
    }
    print('login success:  $user');
    return UserEntity(
        user?.uid, user?.displayName ?? "", user?.email ?? "", "");
  }

  static singOut() {
    FirebaseAuth.instance.signOut();
  }

  static UserEntity getLoggedUser() {
    User? user = FirebaseAuth.instance.currentUser;

    return UserEntity(
        user?.uid, user?.displayName ?? "", user?.email ?? "", "");
  }
}
