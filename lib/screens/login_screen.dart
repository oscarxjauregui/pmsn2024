import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:pmsn2024/screens/dashboard_screen.dart';
import 'package:pmsn2024/services/email_auth_farebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authFirebase = EmailAuthFirebase();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final pwdUser = TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('images/fondo.jpeg'))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 430,
              child: Opacity(
                opacity: .5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  height: 145,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      txtUser,
                      const SizedBox(
                        height: 10,
                      ),
                      pwdUser
                    ],
                  ),
                ),
              ),
            ),
            Image.asset('images/logo_text.png'),
            Positioned(
                bottom: -5,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SignInButton(Buttons.Email, onPressed: () {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        authFirebase
                            .signInUser(
                                password: _passwordController.text,
                                email: _emailController.text)
                            .then((value) {
                          if (!value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No Login',
                                  style: TextStyle(color: Colors.black),
                                ),
                                backgroundColor: Colors.greenAccent,
                              ),
                            );
                          } else {
                            Navigator.pushNamed(context, '/dash').then((value) {
                              setState(() {
                                isLoading = !isLoading;
                              });
                            });
                          }
                        });
                        /*Future.delayed(
                          new Duration(milliseconds: 3000),
                          (){
                            /*Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => new DashboardScreen(),)
                            );*/
                            Navigator.pushNamed(context, "/registro").then((value){
                              setState(() {
                                isLoading = !isLoading;
                              });
                            });
                          }
                        );*/
                      }),
                      SignInButton(Buttons.Google, onPressed: () {
                        Navigator.pushNamed(context, "/dash");
                      }),
                      SignInButton(Buttons.Facebook, onPressed: () {}),
                      SignInButton(Buttons.GitHub, onPressed: () {}),
                    ],
                  ),
                )),
            isLoading
                ? const Positioned(
                    top: 260,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : Container()
          ],
        ),
      ),
    );
  }
}
