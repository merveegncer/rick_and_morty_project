import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rick_and_morty/screens/character/list_characters_page.dart';
import 'package:rick_and_morty/service/auth.dart';

class LoginRegisterPAge extends StatefulWidget {
  const LoginRegisterPAge({super.key});

  @override
  State<LoginRegisterPAge> createState() => _LoginRegisterPAgeState();
}

class _LoginRegisterPAgeState extends State<LoginRegisterPAge> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String image =
      'https://i.ibb.co/DtcCJJz/1acd6b7deb0019f22cd099bcda478bd8.jpg';

  bool islogin = true;
  String? errorMessage;

  Future<void> createUser() async {
    try {
      await Auth().createUser(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GetAndShowCharacters(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        errorMessage = 'Kullanıcı oluşturulamadı: ${e.message}';
      });
    }
  }

  Future<void> signIn() async {
    try {
      await Auth().signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GetAndShowCharacters(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      setState(() {
        errorMessage = 'Giriş yapılamadı: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 52, 71, 124),
          image: DecorationImage(
              fit: BoxFit.cover, opacity: 0.7, image: NetworkImage(image))),
      child: Center(
        child: Container(
          //height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                cursorColor: Color.fromARGB(255, 0, 93, 169),
                controller: emailController,
                decoration: const InputDecoration(
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 97, 177))),
                    fillColor: Color.fromARGB(123, 255, 255, 255),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 34, 156, 255))),
                    hintText: 'email'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                cursorColor: Color.fromARGB(255, 0, 93, 169),
                decoration: const InputDecoration(
                    fillColor: Color.fromARGB(122, 255, 255, 255),
                    filled: true,
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 93, 169))),
                    focusColor: Color.fromARGB(255, 40, 158, 255),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 160, 255))),
                    border: OutlineInputBorder(),
                    hoverColor: Color.fromARGB(255, 0, 93, 169),
                    hintText: 'password'),
              ),
              const SizedBox(
                height: 20,
              ),
              islogin
                  ? const SizedBox()
                  : TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          fillColor: Color.fromARGB(130, 255, 255, 255),
                          filled: true,
                          enabled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 93, 169))),
                          focusColor: Colors.green,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 50, 163, 255))),
                          border: OutlineInputBorder(),
                          hoverColor: Colors.green,
                          hintText: 'name'),
                    ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 100,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 0, 93, 169)),
                      foregroundColor: MaterialStatePropertyAll(Colors.white60),
                      overlayColor: MaterialStatePropertyAll(
                          Color.fromARGB(73, 253, 253, 253))),
                  onPressed: () {
                    if (islogin) {
                      signIn();
                    } else {
                      createUser();
                    }
                  },
                  child: islogin ? const Text('LOGIN') : const Text('register'),
                ),
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      islogin = !islogin;
                    });
                  },
                  child: islogin
                      ? const Text(
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 93, 169)),
                          'register')
                      : const Text(
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 93, 169)),
                          'login'))
            ],
          ),
        ),
      ),
    ));
  }
}
