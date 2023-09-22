import 'package:flutter/material.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _userTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Scaffold(
          appBar: AppBar(
            title: Text("Admin Portal"),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/'),
                  );
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: _schoolController,
                  decoration: InputDecoration(labelText: 'School'),
                ),
                TextField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(labelText: 'Expiry Date'),
                ),
                TextField(
                  controller: _userTypeController,
                  decoration: InputDecoration(labelText: 'User Type'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic to add user will go here
                  },
                  child: Text('Add User'),
                ),
                // Display the list of accounts here
              ],
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _schoolController.dispose();
    _expiryDateController.dispose();
    _userTypeController.dispose();
    super.dispose();
  }
}
