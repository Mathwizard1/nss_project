import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';

final enableborder = OutlineInputBorder(
    borderSide:
        const BorderSide(width: 3, color: Color.fromARGB(255, 175, 178, 175)),
    borderRadius: BorderRadius.circular(12));

final focusborder = OutlineInputBorder(
    borderSide: const BorderSide(width: 3, color: Colors.blue),
    borderRadius: BorderRadius.circular(12));

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  bool _visibility = false;
  var passwordicon = Icons.visibility;

  bool _isLoading = false;
  String _errorMessage = '';

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController rollnumbercontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  Future<void> _trySignUp() async {
    if (_isLoading) {
      return;
    }

    if (emailcontroller.text.trim() == '' ||
        rollnumbercontroller.text.trim() == '' ||
        fullnamecontroller.text.trim() == '' ||
        passwordcontroller.text.trim() == '') {
      setState(() => _errorMessage = 'Can\'t leave one or more fields empty.');
      return;
    }

    if (passwordcontroller.text.trim() !=
        confirmpasswordcontroller.text.trim()) {
      setState(() => _errorMessage = 'Passwords don\'t match.');
      return;
    }

    if (!emailcontroller.text.trim().endsWith('@iitp.ac.in')) {
      setState(() => _errorMessage = 'Please enter an IITP email address.');
      return;
    }

    if ((await FirebaseFirestore.instance
            .collection('users')
            .where('roll-number',
                isEqualTo: rollnumbercontroller.text.trim().toUpperCase())
            .get())
        .docs
        .isNotEmpty) {
      setState(() => _errorMessage =
          'An existing account is already linked to this roll-number.');
      return;
    }

    try {
      setState(() => _isLoading = true);

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailcontroller.text.trim(),
              password: passwordcontroller.text.trim());

      // Wait for FirebaseAuth to update currentUser; without this FirebaseFirestore might receive a create request with the null user, which will be denied
      while (FirebaseAuth.instance.currentUser == null) {
        await Future.delayed(const Duration(seconds: 1));
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'attended-events': [],
        'email': emailcontroller.text.trim(),
        'full-name': fullnamecontroller.text.trim(),
        'group': 'Undecided',
        'hour-deductions': [],
        'registered-events': [],
        'role': 'volunteer',
        'roll-number': rollnumbercontroller.text.trim().toUpperCase(),
        'sem-1-hours': 0,
        'sem-2-hours': 0,
      });

      FocusManager.instance.primaryFocus?.unfocus();

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.sizeOf(context).width;
    final screenheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, screenheight / 20, 0, 0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: 200,
                height: 150,
                child: Image.asset('assets/images/nss-iitp-logo.png')),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 20, screenwidth * 0.5, 20),
                child: const Text('Sign Up',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w900))),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    screenwidth / 10, 0, screenwidth / 10, 0),
                child: TextField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    enabledBorder: enableborder,
                    focusedBorder: focusborder,
                    labelText: 'Enter Email',
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    screenwidth / 10, 20, screenwidth / 10, 0),
                child: TextField(
                  controller: fullnamecontroller,
                  decoration: InputDecoration(
                    enabledBorder: enableborder,
                    focusedBorder: focusborder,
                    labelText: 'Enter Full Name',
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    screenwidth / 10, 20, screenwidth / 10, 0),
                child: TextField(
                  controller: rollnumbercontroller,
                  decoration: InputDecoration(
                    enabledBorder: enableborder,
                    focusedBorder: focusborder,
                    labelText: 'Enter Roll Number',
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    screenwidth / 10, 20, screenwidth / 10, 0),
                child: TextField(
                  obscuringCharacter: '*',
                  obscureText: !_visibility,
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(passwordicon),
                      onPressed: () => {
                        setState(() {
                          if (_visibility == false) {
                            _visibility = true;
                            passwordicon = Icons.visibility_off;
                          } else {
                            _visibility = false;
                            passwordicon = Icons.visibility;
                          }
                        })
                      },
                    ),
                    enabledBorder: enableborder,
                    focusedBorder: focusborder,
                    labelText: 'Enter Password',
                  ),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenwidth / 10, 20, screenwidth / 10, 0),
              child: TextField(
                controller: confirmpasswordcontroller,
                obscuringCharacter: '*',
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: enableborder,
                  focusedBorder: focusborder,
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: SizedBox(
                  width: screenwidth / 3,
                  height: 50,
                  child: TextButton(
                    onPressed: _trySignUp,
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.indigo),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: (_isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit')),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: SizedBox(
                width: 3 * screenwidth / 4,
                child: Center(
                    child: Text((_isLoading ? '' : _errorMessage),
                        style: const TextStyle(color: Colors.red))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have an account? '),
                  GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage())),
                      child: const Text('Login',
                          style: TextStyle(color: Colors.blue)))
                ],
              ),
            )
          ])),
    );
  }
}
