import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/layout/settings/settings.dart';

class MainSideNavBar extends StatelessWidget {
  final String username;
  final String bio;
  MainSideNavBar({required this.username, required this.bio});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(bio),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('bookmarks'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.drafts),
            title: Text('drafts'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
            onTap: () => null,
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    '8',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => navigateTo(context, SettingsScreen()),
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () => AppBloc.get(context).signOut(context),
          ),
        ],
      ),
    );
  }
}
