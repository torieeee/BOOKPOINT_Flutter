import 'package:book_point/components/button.dart';
import 'package:book_point/main.dart';
import 'package:book_point/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool obsecurePass = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Color(0xFF427D7D),
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Color(0xFF427D7D),
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Color(0xFF427D7D),
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Color(0xFF427D7D),
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
                            color: Color(0xFF427D7D),
                          ))),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign In',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await auth.login(
                        _emailController.text, _passController.text);
                    if (auth.isLogin) {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        // Store the UID using shared preferences
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('uid', user.uid);

                        DocumentSnapshot userDoc = await FirebaseFirestore
                            .instance
                            .collection('Users')
                            .doc(user.uid)
                            .get();
                        if (userDoc.exists) {
                          String userType = userDoc['userType'];

                          // Navigate based on user type
                          if (userType == 'Doctor') {
                            MyApp.navigatorKey.currentState!
                                .pushNamed('doctor', arguments: userDoc.data());
                          } else {
                            MyApp.navigatorKey.currentState!.pushNamed('main');
                          }
                        } else {
                          MyApp.navigatorKey.currentState!.pushNamed('main');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login Failed')),
                        );
                      }
                    }
                  }
                },
                disable: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
/*
                 final token = await DioProvider()
                      .getToken(_emailController.text, _passController.text);
                      print(token);
                  if (token) {
                    //auth.loginSuccess(); //update login status
                    //redirect to main page

                    //grab user data here
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final tokenValue = prefs.getString('token') ?? '';

                    if (tokenValue.isNotEmpty && tokenValue != '') {
                      //get user data
                      final response = await DioProvider().getUser(tokenValue);
                      if (response != null) {
                        setState(() {
                          //json decode
                          Map<String, dynamic> appointment = {};
                          final user = json.decode(response);

                          //check if any appointment today
                          for (var doctorData in user['doctor']) {
                            //if there is appointment return for today

                            if (doctorData['appointments'] != null) {
                              appointment = doctorData;
                            }
                          }

                          auth.loginSuccess(user, appointment);
                          MyApp.navigatorKey.currentState!.pushNamed('main');
                        });
                      }
                    }
                  }*/

/*try{
                    final email =_emailController.text;
                    final password=_passController.text;
                    try{
                    final isAuthenticated=await _dbHelper.authService(email,password);
                    if (isAuthenticated) {
      // Update login status
      auth.loginSuccess(email,password);

      // Redirect to the main page
      MyApp.navigatorKey.currentState!.pushNamed('main');
    } else {
      print('Invalid credentials');
    }
  } catch (e) {
    print('Error during login: $e');
  
                  }*/
//                 },
//                 //child:Text('Sign In')
//                 disable: false,
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
