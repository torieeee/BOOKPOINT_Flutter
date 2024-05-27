import 'dart:convert';

import 'package:book_point/components/button.dart';
import 'package:book_point/main.dart';
//import 'package:book_point/models/auth_model.dart';
import 'package:providers/dioprovider.dart';
import 'package:book_point/screens/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}
class _SignUpFormState extends State<SignUpForm>{
  final _formKey=GlobalKey<FormState>();
  final _IdController=TextEditingController();
  final _fnameController=TextEditingController();
  final _lnameController=TextEditingController();
  final _emailController=TextEditingController();
  final _passController=TextEditingController();
  final _confirmPassController=TextEditingController();
  bool obsecurePass=true;
  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _fnameController,
            keyboardType: TextInputType.name,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'First name',
              labelText: 'Name',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          
          Config.spaceSmall,
          TextFormField(
            controller: _lnameController,
            keyboardType: TextInputType.name,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Last name',
              labelText: 'last name',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _IdController,
            keyboardType: TextInputType.number,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'ID number',
              labelText: 'ID',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Config.primaryColor,
                          ))),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _confirmPassController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Confirm password',
                labelText: 'Confirm Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Config.primaryColor,
                          ))),
          ),

        Config.spaceSmall,
          Consumer<Authentication>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign Up',
                onPressed: () async {
                  final userRegistration = await DioProvider().registerUser(
                      _fnameController.text,
                      _lnameController.text,
                      _emailController.text,
                      _IdController.text,
                      _passController.text,
                      _confirmPassController.text
                      );

                  //if register success, proceed to login
                  if (userRegistration) {
                    final token = await DioProvider()
                        .getToken(_emailController.text, _passController.text);

                    if (token) {
                      auth.loginSuccess({}, {}); //update login status
                      //rediret to main page
                      MyApp.navigatorKey.currentState!.pushNamed('main');
                    }
                  } else {
                    print('register not successful');
                  }
                },
                disable: false,
              );
            },
          )
        ] ,
        ),
        );
  }

  

}