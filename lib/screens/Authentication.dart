import 'package:book_point/components/login_form.dart';
import 'package:book_point/components/sign_up_form.dart';
import 'package:book_point/components/social_button.dart';
import 'package:book_point/utils/text.dart';
import 'package:flutter/material.dart';

import '../utils/config.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isSignIn = true;
  

 /* @override
  void initState(){
    Future.delayed(
     const Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginForm() ) , (route)=>)
     }
    );
  }*/
   @override
  Widget build(BuildContext context) {
     Config().init(context);
    //build login text field
    return Scaffold(
        body: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppText.enText['welcome_text']!,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                Text(
                  isSignIn
                    ? AppText.enText['signIn_text']!
                    : AppText.enText['register_text']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                //login
                isSignIn ? LoginForm():SignUpForm(),
                Config.spaceSmall,
                isSignIn
                ?Center(
                  child: TextButton(
                    onPressed:(){},
                    child:Text(
                      AppText.enText['forgot_password']??'',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                  ),
                    ) ,
                    )
                :Container(),
                //social button
                const Spacer(),
                Center(
                  child: Text(
                    AppText.enText['social_login']??'',
                    style: TextStyle(
                      fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade500,
                  ),
                  ),
                ),
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  isSignIn
                      ? AppText.enText['signUp_text']!
                      : AppText.enText['registered_text']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isSignIn = !isSignIn;
                    });
                  },
                  child: Text(
                    isSignIn ? 'Sign Up' : 'Sign In',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}