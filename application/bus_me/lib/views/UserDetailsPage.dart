import 'package:bus_me/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/models/user_management.dart';

import '../controllers/UserDetailsController.dart';

enum UserType { regular, admin }

class UserDetailsPage extends StatefulWidget {

  final User user;

  UserDetailsPage({required this.user});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  //Part of UserDetails
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  //Part of User
  late TextEditingController _usernameController;
  late UserType? _selectedType;
  late DateTime _selectedDate;

  late UserDetailsController _controller;


  late BusMEUserManagement userManagement;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.details?.name);
    _emailController = TextEditingController(text: widget.user.details?.email);
    _phoneController = TextEditingController(text: widget.user.details?.phone);
    _usernameController = TextEditingController(text: widget.user.username);
    _selectedType = widget.user.type == 2 ? UserType.admin : UserType.regular;
    _selectedDate = widget.user.expiry;

    final AuthModel _authModel = BusMEAuth();
    userManagement = BusMEUserManagement(_authModel);
    _controller = UserDetailsController(_authModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),

            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),

            DropdownButton<UserType>(
              value: _selectedType,
              items: <DropdownMenuItem<UserType>>[
                DropdownMenuItem(
                  value: UserType.regular,
                  child: Text('Regular User'),
                ),
                DropdownMenuItem(
                  value: UserType.admin,
                  child: Text('Admin User'),
                ),
              ],
              onChanged: (UserType? newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
            ),


            TextButton(
              child: Text("Select expiry date"),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null && pickedDate != _selectedDate)
                  setState(() {
                    _selectedDate = pickedDate;
                  });
              },
            ),


            ElevatedButton(
              onPressed: () async {

                if (!_controller.isValidEmail(_emailController.text)) {
                  _showDialog('Invalid Email', 'Please provide a valid email address.');
                  return;
                }

                if (!_controller.isValidPhone(_phoneController.text)) {
                  _showDialog('Invalid Phone Number', 'Phone number should only contain numbers.');
                  return;
                }

                widget.user.details?.name = _nameController.text;
                widget.user.details?.email = _emailController.text;
                widget.user.details?.phone = _phoneController.text;
                widget.user.username = _usernameController.text;
                widget.user.expiry = _selectedDate;

                int userTypeValue;
                if (_selectedType == UserType.admin) {
                  userTypeValue = 2;
                } else {
                  userTypeValue = 1;
                }

                widget.user.type = userTypeValue;

                int updateStatus = await userManagement.updateUser(
                    widget.user.id, widget.user);
                if (updateStatus != 0) {
                  _showDialog('Error', 'Update Failed. Username may be taken.');
                } else {
                  _showDialog('Success', 'User Updated Successfully');
                }
              },
              child: Text('Save'),
            ),

            ElevatedButton(
              onPressed: () async {
                int deleteStatus = await _controller.deleteUser(widget.user.id);
                if (deleteStatus != 0) {
                  _showDialog('Error', 'Deletion Failed');
                } else {
                  _showDialog('Success', 'Deletion Successful').then((_) {
                    Navigator.of(context).pop(); // The user doesn't exist anymore so pop again
                  });
                }
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog(String title, String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}


