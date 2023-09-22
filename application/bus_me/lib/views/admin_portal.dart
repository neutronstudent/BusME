import 'package:flutter/material.dart';
import 'package:bus_me/controllers/admin_portal_controller.dart';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/views/UserDetailsPage.dart';
import 'package:bus_me/models/auth_model.dart';

class AdminPortal extends StatefulWidget {
  @override
  _AdminPortalState createState() => _AdminPortalState();
}

class _AdminPortalState extends State<AdminPortal> {
  final AdminPortalController _controller = AdminPortalController();
  final AuthModel _authModel = BusMEAuth();

  @override
  void initState() {
    super.initState();
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              onChanged: _controller.search,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<User>>(
              stream: _controller.userStream,
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
                            builder: (context) => UserDetailsPage(user: user, authModel: _authModel),
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
