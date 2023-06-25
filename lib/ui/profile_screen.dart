import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase_login/firebase_helper.dart';
import 'package:flutter_18_firebase_login/ui/login_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

const url =
    'https://us-central1-flutter18-firebase-login.cloudfunctions.net/stripePaymentIntentRequest';

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
  bool hasSub = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _initUserData();
    _initDataNotes();
    observeSubscriptionState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: // loading ? const CircularProgressIndicator():
          hasSub ? fullScreen : subScreen,
    );
  }

  Widget get fullScreen => Container(
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
      );

  Widget get subScreen => Container(
        padding:
            const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 10),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
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
                height: 350,
              ),
              buildElevatedButtonAccessNotes(),
              const SizedBox(
                height: 50,
              ),
              buildExitTextButton(),
            ],
          ),
        ),
      );

  Future test() async {
    await FirebaseHelper.completeSubscription(false);
  }

  Future<void> initPaymentSheet(context,
      {required String email, required int amount}) async {
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
            url,
          ),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      //2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment completed!'),
          backgroundColor: Color(0xFF17E444),
        ),
      );
      await FirebaseHelper.completeSubscription(true);
    } catch (e) {
      log(e.toString());
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future observeSubscriptionState() async {
    await Future.delayed(const Duration(seconds: 0));
    FirebaseHelper.subscriptionState().listen((event) {
      final state = event.snapshot.value;
      if (state == null) return;
      final success = (state as bool?);
      if (success == null) return;
      setState(() {
        hasSub = success;
        loading = false;
      });
    });
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
                    _showDialogUpdateNote(index);
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
          _showDialogAddNote();
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

  Widget buildElevatedButtonAccessNotes() {
    return Center(
      child: ElevatedButton(
        onPressed: () =>
            initPaymentSheet(context, email: "example@gmail.com", amount: 200),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF17E444),
          fixedSize: const Size(184, 40),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: const Text(
          'Access notes',
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

  Future<void> _initUserData() async {
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
        });
      }
    });
  }

  void _deleteNote(int index) async {
    await FirebaseHelper.deleteNote(index);
    setState(() {
      //notes.removeAt(index);
    });
  }

  Future _showDialogAddNote() => showGeneralDialog(
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
                  await FirebaseHelper.addNote(note);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );

  Future _showDialogUpdateNote(index) => showGeneralDialog(
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
                  final oldNote = notes[index];
                  final newNote = nameController.text;
                  await FirebaseHelper.updateNote(oldNote, newNote);
                  setState(() {});
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
}
