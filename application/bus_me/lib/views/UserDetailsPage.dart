import 'package:bus_me/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/models/user_management.dart';

class UserDetailsPage extends StatefulWidget {
  final User user;

  UserDetailsPage({required this.user});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late TextEditingController _nameController;
  late BusMEUserManagement userManagement;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.details?.name);
    final AuthModel _authModel = BusMEAuth();
    userManagement = BusMEUserManagement(_authModel); // Initialize userManagement here
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
            ElevatedButton(
              onPressed: () async {
                widget.user.details?.name = _nameController.text;

                int updateStatus = await userManagement.updateUser(widget.user.id, widget.user);
                if (updateStatus != 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Update Failed'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the AlertDialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('User Updated Successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the AlertDialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Save'),
            ),

            ElevatedButton(
              onPressed: () async {
                int deleteStatus = await userManagement.deleteUser(widget.user.id);
                if (deleteStatus != 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Deletion Failed'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the AlertDialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('Deletion Successful'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the AlertDialog
                              Navigator.of(context).pop(); // The user doesn't exist anymore so pop again
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Delete'),
            ),

          ],
        ),
      ),
    );
  }
}

