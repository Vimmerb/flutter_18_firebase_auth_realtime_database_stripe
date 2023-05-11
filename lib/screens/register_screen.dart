import 'package:flutter/material.dart';
import 'package:flutter_18_firebase_login/firebase_helper.dart';
import 'package:flutter_18_firebase_login/screens/login_screen.dart';
import 'package:flutter_18_firebase_login/screens/profile_screen.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  String? _name;
  String? _email;
  String? _password;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildNameText(),
                buildNameField(),
                const SizedBox(
                  height: 15,
                ),
                buildEmailText(),
                buildEmailField(),
                const SizedBox(
                  height: 15,
                ),
                buildPasswordText(),
                buildPasswordField(),
                const SizedBox(
                  height: 15,
                ),
                buildRePasswordText(),
                buildRePasswordField(),
                const SizedBox(
                  height: 40,
                ),
                buildElevatedButtonRegister(),
                const SizedBox(
                  height: 50,
                ),
                buildOldAccountTextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameText() {
    return const Text(
      'Your name*',
      style: TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
    );
  }

  Widget buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: const TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        fillColor: Color(0xFFD9D9D9),
        filled: true,
      ),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your name';
        }
        return null;
      },
      onChanged: (value) => setState(() => _name = value),
    );
  }

  Widget buildEmailText() {
    return const Text(
      'Email*',
      style: TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        fillColor: Color(0xFFD9D9D9),
        filled: true,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your email address';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Enter a valid email address';
        }
        return null;
      },
      onChanged: (value) => setState(() => _email = value),
    );
  }

  Widget buildPasswordText() {
    return const Text(
      'Password*',
      style: TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: const Color(0xFFD9D9D9),
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      ),
      obscureText: !_showPassword,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onChanged: (value) => setState(() => _password = value),
    );
  }

  Widget buildRePasswordText() {
    return const Text(
      'Repeat password*',
      style: TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
    );
  }

  Widget buildRePasswordField() {
    return TextFormField(
      style: const TextStyle(
        fontFamily: 'Inter-SemiBold',
        fontSize: 16,
        color: Color(0xFF000000),
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: const Color(0xFFD9D9D9),
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      ),
      obscureText: !_showPassword,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Repeat the password';
        }
        if (value != _passwordController.text) {
          return 'Incorrect password';
        }
        return null;
      },
      onChanged: (value) => setState(() => _password = value),
    );
  }

  Widget buildElevatedButtonRegister() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final name = _nameController.text;
            final email = _emailController.text;
            final password = _passwordController.text;

// TODO
            final success =
                await FirebaseHelper.register(name, email, password);
            if (success) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const ProfileWidget();
                }),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration completed'),
                  backgroundColor: Color(0xFF17E444),
                ),
              );
            }
            // else
            // {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(
            //       backgroundColor: Colors.red,
            //       content: Text('Something went wrong'),
            //     ),
            //   );
            // }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Passwords are not the same'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF17E444),
          fixedSize: const Size(184, 40),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            fontFamily: 'Inter-SemiBold',
            color: Color(0xFF1A1717),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildOldAccountTextButton() {
    return Center(
      child: TextButton(
        child: Text(
          'ALREADY REGISTERED',
          style: TextStyle(
            fontFamily: 'Inter-SemiBold',
            fontSize: 16,
            color:
                _isPressed ? const Color(0xFF17E444) : const Color(0xFF000000),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isPressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 50));

          // TODO
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return LoginWidget();
            }),
          );
        },
      ),
    );
  }
}
