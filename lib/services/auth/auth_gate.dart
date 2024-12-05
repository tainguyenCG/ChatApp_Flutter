import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../pages/home_page.dart';
import 'login_or_register.dart';
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            //use is logged in
            if (snapshot.hasData){
              return HomePage();
            }

            //use isNOT logged in
            else{
              return const LoginOrRegister();
            }
          }
      ),
    );
  }
}
