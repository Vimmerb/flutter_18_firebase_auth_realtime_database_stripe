import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_18_firebase_login/ui/profile_screen.dart';

class FirebaseHelper {
  // Регистрация / аутентификация gjkmp
  static Future<bool> login(String email, String password) async {
    try {
      // FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // FirebaseAuth.instance.currentUser!.emailVerified;
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      // Код ошибка для случая, если пользователь не найден
      if (e.code == 'user-not-found') {
        print("Unknown user");
        // Код ошибка для случая, если пользователь ввёл неверный пароль
      } else if (e.code == 'wrong-password') {
        print("Wrong password");
      }
    } catch (e) {
      print("Unknown error");
    }
    return false;
  }

  static Future<bool> register(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email address.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // ///
  // static String? getEmail() {
  //   return FirebaseAuth.instance.currentUser?.email;
  // }

// Платная активация заметок
  static Future<void> completeSubscription(bool value) async {
    // Берём id пользователя, чтобы у каждого пользователя была своя ветка
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return;
    // Берём ссылку на корень дерева с записями для текущего пользователя
    final ref = FirebaseDatabase.instance.ref("subscriptions/$id/enable");
    // Сначала генерируем новую ветку с помощью push() и потом в эту же ветку
    // добавляем запись
    await ref.set(value);
  }

  static Stream<DatabaseEvent> subscriptionState() {
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return const Stream.empty();
    final ref = FirebaseDatabase.instance.ref("subscriptions/$id/enable");
    return ref.onValue;
  }

// Заметки
  static Future<void> addNote(String note) async {
    // Берём id пользователя, чтобы у каждого пользователя была своя ветка
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return;
    // Берём ссылку на корень дерева с записями для текущего пользователя
    final ref = FirebaseDatabase.instance.ref("notes/$id");
    // Сначала генерируем новую ветку с помощью push() и потом в эту же ветку
    // добавляем запись
    await ref.push().set(note);
  }

  static Stream<DatabaseEvent> getNotes() {
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return const Stream.empty();
    final ref = FirebaseDatabase.instance.ref("notes/$id");
    return ref.onValue;
  }

  static Future<void> deleteNote(int index) async {
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return;
    final ref = FirebaseDatabase.instance.ref("notes/$id");
    final snapshot = await ref.get();
    final map = snapshot.value as Map<dynamic, dynamic>?;
    if (map != null) {
      final entryToDelete = map.entries.elementAt(index);
      await ref.child(entryToDelete.key).remove();
    }
  }

  static Future<void> updateNote(String oldNote, String newNote) async {
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return;
    final ref = FirebaseDatabase.instance.ref("notes/$id");
    final snapshot = await ref.get();
    final map = snapshot.value as Map<dynamic, dynamic>?;
    if (map != null) {
      final item = map.entries.firstWhere((entry) => entry.value == oldNote);
      //await FirebaseDatabase.instance.ref("note/$id/${item.key}").set(newNote);
      await ref.child(item.key).set(newNote);
    }
  }
}
