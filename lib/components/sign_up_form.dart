import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/auth_model.dart';
//import '../providers/dio_provider.dart';
import '../utils/config.dart';
import 'button.dart';
import 'package:book_point/providers/database_connection.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isSigningUp = false;
  bool obsecurePass = true;

  late DatabaseHelper _dbHelper;
  @override
  void initState() {
    super.initState();
    
    _dbHelper = DatabaseHelper(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '',
      databaseName: 'book_point',
    );
    _dbHelper.openConnection();
  }

  @override
  void dispose() {
    _dbHelper.closeConnection(); // Close database connection
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
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Username',
              labelText: 'Username',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
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
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign Up',
                onPressed: () async {

                 /* final username=_nameController.text;
                  final email=_emailController.text;
                  final password=_passController.text;

                  try{
                    final userRegistration=await _dbHelper.registerUser(username, email, password);

                    if (userRegistration){
                      final isAuthenticated=await _dbHelper.authService(email, password);

                       if(isAuthenticated){
                        auth.loginSuccess(email, password);
                        MyApp.navigatorKey.currentState!.pushNamed('main');
                       }

                    }else{
                      print('Registration not successful');

                    }

                  }catch(e){
                    print('Error during registration');

                  }*/
            
                  /*final userRegistration = await DioProvider().registerUser(
                      _nameController.text,
                      _emailController.text,
                      _passController.text);

                  // //if register success, proceed to login
                  // if (userRegistration) {
                  //   final token = await DioProvider()
                  //       .getToken(_emailController.text, _passController.text);

                    if (token) {
                      auth.loginSuccess({}, {}); //update login status
                      //rediret to main page
                      MyApp.navigatorKey.currentState!.pushNamed('main');
                    }
                  } else {
                    print('register not successful');
                  }*/
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}

//now, let's get all doctor details and display on Mobile screen