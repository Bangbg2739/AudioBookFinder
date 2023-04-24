import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);
  static String id = '/Login_Register_Page';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  
  final TextEditingController passController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  
  Future<void> SignInWithEmailAndPassword() async { 
    try{
      await Auth().SignInWithEmailAndPassword(
        email: mailController.text, 
        password: passController.text, 
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try{
      await Auth().createUserWithEmailAndPassword(
        email: mailController.text, 
        password: passController.text, 
      );
    }on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title(){
    return const Text('Audiobooks Finder');
  }

  Widget _entryField( String title, TextEditingController editingController,) {
    return TextField(
      controller: editingController,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: title,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _errorMessage(){
    return Text(errorMessage==''? '' : 'Hmm ? $errorMessage',style: TextStyle(color: Colors.white,),);
  }

  Widget _submitButton(){
    return ElevatedButton(
      onPressed: isLogin? SignInWithEmailAndPassword : createUserWithEmailAndPassword , 
      child:Text(isLogin? 'Login':'Register') );
  }

  Widget _LoginOrRegisterButton(){
    return TextButton(
      onPressed:(){
        setState(() {
          isLogin =!isLogin;
        });
      }, 
      child: Text(isLogin? 'Register instead':'Login instead'),
      );
  }

  Widget _Logo(){
    return Image(
      image: NetworkImage('https://images.unsplash.com/photo-1501808503570-36559610f95e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1071&q=80'),
      height: 180,
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:_title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('\nAudiobooks Finder\n', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25, ),),
            _Logo(),
            Text(isLogin? '\nLogin\n':'\nRegister\n', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
            _entryField('email', mailController),
            Text('\n'),
            _entryField('password', passController),
            _errorMessage(),
            _submitButton(),
            _LoginOrRegisterButton(),
          ],
        ),
      ),
    ),
    );
  }
}