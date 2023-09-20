
import 'package:bus_me/observable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget
{
  final Observable loginObservable = BaseObservable();

  LoginPage({Key? key}):
        super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
{

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return
      Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          //all children of login menu
          children: [

            //title
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: const Text(
                'BusME',
                style: TextStyle(
                  fontSize: 48
                ),
              ),
            ),

            //login text
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: const Text(
                'Login',
                style: TextStyle(
                    fontSize: 18
                ),
              ),
            ),

            //login boxes
            //username field
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username"
                ),
              )
            ),

            Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password"
                  ),
                )
            ),
            //enty button
            Container(

                padding: const EdgeInsets.fromLTRB(10, 0, 10 , 0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize:  const Size.fromHeight(40)),
                  onPressed:  () async {
                    await widget.loginObservable.notifyObservers(
                        ObsSignal("login", {"username": usernameController.text, "password": passwordController.text})
                    );
                  },
                  child: const Text(
                    'login',
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                )
            ),

          ],
        )
      );
  }
}
