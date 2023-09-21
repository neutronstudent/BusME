import 'package:flutter/material.dart';
import 'package:bus_app/main_map_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _textEmailController = TextEditingController();
  TextEditingController _textPasswordController = TextEditingController();

  String validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return "";
  }

  String validateEmail(String value) {
    if (!(value.length > 1) && value.isNotEmpty) {
      return "Email should contain more than 1 characters";
    }
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(value);
    if (emailValid) {
      return "Email accepted";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    const double gap = 10;
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              children: [
                Column(
                  children: [
                    Image(image: AssetImage('assets/images/logo.png')),
                  ],
                ),
                SizedBox(height: gap),
                Column(
                  children: [
                    TextField(
                      controller: _textEmailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        labelText: 'Email',
                        errorText: validateEmail(_textEmailController.text),
                        hintText: 'yourname@email.com',
                      ),
                    )
                  ],
                ),
                SizedBox(height: gap),
                Column(
                  children: [
                    TextField(
                      controller: _textPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
                        errorText:
                            validatePassword(_textPasswordController.text),
                        hintText: '********',
                      ),
                    )
                  ],
                ),
                SizedBox(height: gap),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size.fromHeight(
                        60), // fromHeight use double.infinity as width and 40 is the height
                  ),
                  onPressed: () {
                    if (validatePassword(_textEmailController.text) == '' &&
                        validateEmail(_textPasswordController.text) == '') {
                      print(_textEmailController.text);
                      print(_textPasswordController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                )
              ],
            ),
          ),
        ));
  }
}
