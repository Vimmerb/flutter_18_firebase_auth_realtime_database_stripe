// import 'package:flutter/material.dart';
// import 'package:flutter_18_firebase_login/firebase_helper.dart';
// import 'package:flutter_18_firebase_login/screens/login_screen.dart';
// import 'package:flutter_18_firebase_login/firebase_helper.dart';
// import 'package:flutter_18_firebase_login/screens/profile_screen.dart';

// abstract class _WidgetClassState {
//   String? _name;
//   String? _email;
//   List<String> notes = [];
//   bool _isPressed = false;
//   // bool hasSub = false;
//   // bool loading = true;

//   Widget buildHelloText() {
//     return Center(
//       child: Text(
//         'Hello, $_name!',
//         //'Hello!',
//         style: const TextStyle(
//           fontFamily: 'Inter-Black',
//           fontSize: 25,
//           color: Color(0xFF000000),
//         ),
//       ),
//     );
//   }

//   Widget buildEmailText() {
//     return Center(
//       child: Text(
//         //'email',
//         '$_email',
//         style: const TextStyle(
//           fontFamily: 'Inter-Black',
//           fontSize: 16,
//           color: Color(0xFF000000),
//         ),
//       ),
//     );
//   }

//   Widget buildAvatar() {
//     return const Center(
//       child: CircleAvatar(
//         radius: 38,
//         backgroundColor: Color(0xFF17E444),
//         child: CircleAvatar(
//           backgroundImage: NetworkImage(
//               'https://img.icons8.com/ios/512/question-mark--v1.png'),
//           radius: 35,
//         ),
//       ),
//     );
//   }

//   Widget buildMyNoteText() {
//     return const Text(
//       'My notes',
//       style: TextStyle(
//         fontFamily: 'Inter-SemiBold',
//         fontSize: 16,
//         color: Color(0xFF000000),
//       ),
//     );
//   }

//   Widget buildNotesList() {
//     return Expanded(
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFFD9D9D9),
//         ),
//         child: ListView.builder(
//           itemCount: notes.length,
//           itemBuilder: (_, index) => ListTile(
//             title: Text(
//               notes[index],
//               style: const TextStyle(
//                 fontFamily: 'Inter-SemiBold',
//                 fontSize: 16,
//                 color: Color(0xFF000000),
//               ),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () async {
//                     _showDialogUpdateNote(index);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () => _deleteNote(index),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildElevatedButtonAddNote() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           _showDialogAddNote();
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF17E444),
//           fixedSize: const Size(184, 40),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.zero,
//           ),
//         ),
//         child: const Text(
//           'Add note',
//           style: TextStyle(
//             fontFamily: 'Inter-SemiBold',
//             color: Color(0xFF1A1717),
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildElevatedButtonAccessNotes() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () =>
//             initPaymentSheet(context, email: "example@gmail.com", amount: 200),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF17E444),
//           fixedSize: const Size(184, 40),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.zero,
//           ),
//         ),
//         child: const Text(
//           'Access notes',
//           style: TextStyle(
//             fontFamily: 'Inter-SemiBold',
//             color: Color(0xFF1A1717),
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildExitTextButton() {
//     return Center(
//       child: TextButton(
//         child: Text(
//           'EXIT',
//           style: TextStyle(
//             fontFamily: 'Inter-SemiBold',
//             fontSize: 16,
//             color:
//                 _isPressed ? const Color(0xFF17E444) : const Color(0xFF000000),
//           ),
//         ),
//         onPressed: () async {
//           // TODO
//           FirebaseHelper.logout();
//           setState(() {
//             _isPressed = true;
//           });
//           await Future.delayed(const Duration(milliseconds: 50));
//           // ignore: use_build_context_synchronously
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) {
//               return const LoginWidget();
//             }),
//           );
//         },
//       ),
//     );
//   }
// }
