import 'package:book_point/components/login_form.dart';
import 'package:book_point/utils/config.dart';
import 'package:book_point/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
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
                  AppText.enText['signIn_text']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                //login
                LoginForm(),
                Config.spaceSmall,
                Center(
                  child: TextButton(
                    onPressed:(){},
                    child:Text(
                      AppText.enText['forgot_password']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                  ),
                    ) ,),
                )
              ],
            ))));
  }
}
