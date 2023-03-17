import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_feild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
   LoginPage({ Key? key }) : super(key: key);

    static String id = 'LoginPage';


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(              
              children: [               
                SizedBox(height: 75,),
                Image.asset('assets/images/scholar.png',
                height: 100,),
                Center(
                  child: Text('Scholar Chat',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'Pacifico',
                  ),
                  ),
                ),
                SizedBox(height: 75,),
                Row(
                  children: [
                    Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                CustomFormTextFeild(
                  onChanged: (data){
                    email = data;
                  },
                  hintText : 'Email',
                ),
                SizedBox(height: 10,),
                CustomFormTextFeild(
                  obscureText: true,
                  onChanged: (data){
                    password = data;
                  },
                  hintText : 'Password',
                ),
                SizedBox(height: 20,),
                CustomButton(
                    onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {
                        
                      });
                      try {
                        await signInUser();
                        Navigator.pushNamed(context, ChatPage.id , arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackBar(context, 'No user found for that email');
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(context, 'Wrong password provided for that user');
                        }
                      } catch (e) {
                        showSnackBar(context, 'There was an error');
                      }
                      isLoading = false;
                      setState(() {
                        
                      });
                    }
                  },
                  text: 'Sign in',
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('don’t have an account ? ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: Text('Register',
                      style: TextStyle(
                        color: Color(0xFFC7EDE6),
                      ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> signInUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
