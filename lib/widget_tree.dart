import 'package:flutter/material.dart';
import 'package:audio_book_finder/auth.dart';
import 'package:audio_book_finder/home.dart';
import 'package:audio_book_finder/login_register.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState()=>_WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: Auth().authStatesChanged,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return HomePage();
        }
        else{
          return LoginPage();
        }
      },
    );
  }
}