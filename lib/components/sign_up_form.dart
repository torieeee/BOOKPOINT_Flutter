import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/auth_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/config.dart';
import 'button.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();

  Future<void> createPatientInFirestore(
      String userId, String name, String email) async {
    try {
      await FirebaseFirestore.instance.collection('patients').doc(userId).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Patient created in Firestore');
    } catch (e) {
      print('Error creating patient in Firestore: $e');
    }
  }
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  final List<String> _userTypes = ['Doctor', 'Patient'];
  final List<String> _doctorTypes = [
    'General Practitioner',
    'Cardiologist',
    'Pediatrician',
    'Neurologist',
    'Dermatologist'
  ];
  String? _selectedUserType;
  String? _selectedDoctorType;
  
  @override
  void dispose() {
    _nameController.dispose();
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
          // Radio buttons for user type selection
          Column(
            children: _userTypes.map((String type) {
              return Column(
                children: [
                  RadioListTile<String>(
                    title: Text(type),
                    value: type,
                    groupValue: _selectedUserType,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedUserType = value;
                        if (value != 'Doctor') {
                          _selectedDoctorType = null;
                        }
                      });
                    },
                  ),
                  if (type == 'Doctor' && _selectedUserType == 'Doctor')
                    DropdownButtonFormField<String>(
                      value: _selectedDoctorType,
                      hint: Text('Select Doctor Type'),
                      items: _doctorTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDoctorType = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              Future<void> createPatientInFirestore(
                  String userid, String name, String email) async {
                if (auth.userId == null) {
                  print('Error: User ID is null');
                  return;
                }

                try {
                  await FirebaseFirestore.instance
                      .collection('patients')
                      .doc(auth.userId)
                      .set({
                    'id': userid,
                    'name': name,
                    'email': email,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  print('Patient created in Firestore with ID: ${auth.userId}');
                } catch (e) {
                  print('Error creating patient in Firestore: $e');
                }
              }

              return Button(
                width: double.infinity,
                title: 'Sign Up',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedUserType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a user type')),
                      );
                      return;
                    }
                    if (_selectedUserType == 'Doctor' &&
                        _selectedDoctorType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a doctor type')),
                      );
                      return;
                    }
                    await auth.register(
                      _nameController.text,
                      _emailController.text,
                      _passController.text,
                      _selectedUserType!,
                      // _selectedDoctorType!,
                    );
                    if (auth.isLogin) {
                      MyApp.navigatorKey.currentState!.pushNamed('/');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration failed')),
                      );
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
                  /*GestureDetector(
                    OnTap(){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=>LoginForm()))
                    }
                  );*/
                /*},
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}*/

//now, let's get all doctor details and display on Mobile screen