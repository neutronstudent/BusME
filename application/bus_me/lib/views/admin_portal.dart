import 'package:flutter/material.dart';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/views/UserDetailsPage.dart';
import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/models/user_management.dart';

class AdminPortal extends StatefulWidget {

  AuthModel _authModel;

  AdminPortal(this._authModel);

  @override
  _AdminPortalState createState() => _AdminPortalState();
}

class _AdminPortalState extends State<AdminPortal> {
  late BusMEUserManagement _userManagement;
  late Future<List<User>> usersFuture;

  @override
  void initState() {
    super.initState();
    _userManagement = BusMEUserManagement(widget._authModel);
    usersFuture = _userManagement.searchUser(""); // Initially get all users
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Portal'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  usersFuture = _userManagement.searchUser(value); // Update the future when search value changes
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No users found');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return ListTile(
                        title: Text(user.username),
                        onTap: () {
                          // Navigate to user details page and pass the user object
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserDetailsPage(user: user, authModel: widget._authModel),
                          ));
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
