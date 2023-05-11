import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase_login/firebase_helper.dart';
import 'package:flutter_18_firebase_login/screens/login_screen.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String? _name;
  String? _email;
  List<String> notes = [];
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initUserData();
    _initDataNotes();
  }

  Future<void> _initUserData() async {
    // TODO
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    final name = FirebaseAuth.instance.currentUser?.displayName ?? '';
    setState(() {
      _email = email;
      _name = name;
    });
  }

  void _initDataNotes() {
    FirebaseHelper.getNotes().listen((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map != null) {
        setState(() {
          notes = map.values.map((e) => e as String).toList();
          FirebaseHelper.noteIds = map.keys.toList();
        });
      }
    });
  }

  void _deleteNote(int index) async {
    final noteId = FirebaseHelper.noteIds[index];
    await FirebaseHelper.deleteNote(noteId);
    setState(() {
      notes.removeAt(index);
    });
  }

  Future _showDialog() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          return AlertDialog(
            title: const Text('New note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final note = nameController.text;
                  FirebaseHelper.write(note);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );

  Future _showDialogUpdate(index) => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController(text: notes[index]);
          return AlertDialog(
            title: const Text('Edit note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final updatedNote = nameController.text;
                  final noteId = FirebaseHelper.noteIds[index];
                  await FirebaseHelper.updateNote(noteId, updatedNote);
                  setState(() {
                    notes[index] = updatedNote;
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 10),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                buildAvatar(),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHelloText(),
                      buildEmailText(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            buildMyNoteText(),
            buildNotesList(),
            const SizedBox(
              height: 35,
            ),
            buildElevatedButtonAddNote(),
            const SizedBox(
              height: 50,
            ),
            buildExitTextButton(),
          ],
        ),
      ),
    );
  }

  Widget buildHelloText() {
    return Center(
      child: Text(
        'Hello, $_name!',
        style: const TextStyle(
          fontFamily: 'Inter-Black',
          fontSize: 25,
          color: Color(0xFF000000),
        ),
      ),
    );
  }

  Widget buildEmailText() {
    return Center(
      child: Text(
        '$_email',
        style: const TextStyle(
          fontFamily: 'Inter-Black',
          fontSize: 16,
          color: Color(0xFF000000),
        ),
      ),
    );
  }

  Widget buildAvatar() {
    return const Center(
      child: CircleAvatar(
        radius: 38,
        backgroundColor: Color(0xFF17E444),
        child: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://img.icons8.com/ios/512/question-mark--v1.png'),
          radius: 35,
        ),
      ),
    );
  }

  Widget buildMyNoteText() {
    return const Text(
      'My notes',
      style: TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
    );
  }

  Widget buildNotesList() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
        ),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (_, index) => ListTile(
            title: Text(
              notes[index],
              style: const TextStyle(
                fontFamily: 'Inter-SemiBold',
                fontSize: 16,
                color: Color(0xFF000000),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    _showDialogUpdate(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteNote(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildElevatedButtonAddNote() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _showDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF17E444),
          fixedSize: const Size(184, 40),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: const Text(
          'Add note',
          style: TextStyle(
            fontFamily: 'Inter-SemiBold',
            color: Color(0xFF1A1717),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildExitTextButton() {
    return Center(
      child: TextButton(
        child: Text(
          'EXIT',
          style: TextStyle(
            fontFamily: 'Inter-SemiBold',
            fontSize: 16,
            color:
                _isPressed ? const Color(0xFF17E444) : const Color(0xFF000000),
          ),
        ),
        onPressed: () async {
          // TODO
          FirebaseHelper.logout();
          setState(() {
            _isPressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 50));
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const LoginWidget();
            }),
          );
        },
      ),
    );
  }
}
