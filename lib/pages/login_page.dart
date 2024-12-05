import 'package:chatapptute/components/my_button.dart';
import 'package:chatapptute/components/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  //email vs pw text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
   LoginPage({
     super.key,
     required this.onTap,
   });

   //go to register page
 final void Function() ? onTap;

//login method
  void login(BuildContext context) async{
    //auth service
     final authService = AuthService();

     //try login
    try{
      await authService.signInWithEmailPassword(
        _emailController.text,
          _pwController.text
      );
    }
    //catch any errors
    catch (e){
      showDialog(context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Lottie.asset(
              'lib/assets/login.json',
              width: 300,
              height: 300,
            ),
            //welcome back message
          Text("welcome back massege", style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),),

            SizedBox(height: 4,),

            //email textfield
          MyTextfield(
            hintText: 'Email',
            obscureText: false,
            controller: _emailController,
          ),

            SizedBox(height: 10,),

            //password textfield
          MyTextfield(
              hintText: 'PassWord',
              obscureText: true,
              controller: _pwController ,
            ),

            SizedBox(height: 20,),

            //login button
          MyButton(
            text: 'Login',
            onTap: () => login(context),
          ),

            SizedBox(height: 25,),

            //register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?', style: TextStyle(color: Theme.of(context).colorScheme.primary ),),
                GestureDetector(
                    onTap: onTap,
                    child: Text(' Register now', style: TextStyle(fontWeight: FontWeight.bold),)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
