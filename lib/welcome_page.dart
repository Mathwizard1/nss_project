import 'package:flutter/material.dart';
import 'package:nss_project/login_page.dart';

class WelcomePage extends StatelessWidget {

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return TweenAnimationBuilder(
      tween:Tween<double>(begin: 0,end: 1),
                duration: const Duration(seconds: 2),
                builder: (context, value, child) {
                  return Opacity(opacity: value,child: child,);
                },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: 400,
                height: 300,
                child: Image.asset('assets/images/nss-iitp-logo.png')),
            Padding(
              padding: EdgeInsets.fromLTRB(0, height / 16, 0, 0),
              child: const Column(
                children: <Widget>[
                  Text("National Social Service",
                      style: TextStyle(
                          fontSize: 30,
                                color: Colors.indigo,
                          fontWeight: FontWeight.bold)),
                  Text("IIT Patna",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                      ],
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, height / 8, 0, 0),
                child: FractionallySizedBox(
                    widthFactor: 0.89,
                    child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Colors.indigo),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage())),
                      },
                      child: const Text("Get Started"),
                    ))),
          ]))),
    );
  }
}
