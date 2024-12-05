import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  //email vs pw text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _comfirmPwController = TextEditingController();
   RegisterPage({
     super.key,
     required this.onTap,
   });

  //go to register page
  final void Function() ? onTap;
   void register(BuildContext context){
     //get auth service
  final _auth = AuthService();
  //password match ->creat user
  if(_pwController.text == _comfirmPwController.text){
    try{
      _auth.signUpWithEmailPassword(
              _emailController.text,
              _pwController.text);
    } catch (e){
      showDialog(context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ));
    }
  }
  //passwords dont match -> tell user to fix
     else{
    showDialog(context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password don't match! "),
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
              'lib/assets/register.json',
              width: 300,
              height: 260,
            ),
            //welcome back message
            Text("Let's create an account for you", style: TextStyle(
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

            SizedBox(height: 8,),

            //password textfield
            MyTextfield(
              hintText: 'PassWord',
              obscureText: true,
              controller: _pwController ,
            ),

            SizedBox(height: 8,),

            //confirm-password textfield
            MyTextfield(
              hintText: 'Confirm passWord',
              obscureText: true,
              controller: _comfirmPwController ,
            ),

            SizedBox(height: 15,),

            //login button
            MyButton(
              text: 'Register',
              onTap: ()=> register(context),
            ),

            SizedBox(height: 10,),

            //register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an accuont?', style: TextStyle(color: Theme.of(context).colorScheme.primary ),),
                GestureDetector(
                    onTap: onTap,
                    child: Text(' Login now', style: TextStyle(fontWeight: FontWeight.bold),)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
