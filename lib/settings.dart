import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

Widget Settings() {
  return SettingsList(
    sections: [
      SettingsSection(
        title: 'App Settings',
        tiles: [
          SettingsTile(
            title: 'Language',
            subtitle: 'English',
            leading: Icon(Icons.language),
            onPressed: (BuildContext context) {},
          ),
          SettingsTile.switchTile(
            title: 'Use fingerprint',
            leading: Icon(Icons.fingerprint),
            switchValue: false,
            onToggle: (bool value) {},
          ),
          SettingsTile.switchTile(
            title: 'Use my location',
            leading: Icon(Icons.gps_fixed),
            switchValue: true,
            onToggle: (bool value) {},
          ),
        ],
      ),
      SettingsSection(
        title: 'Personal Settings',
        tiles: [
          SettingsTile(
            title: 'Language',
            subtitle: 'English',
            leading: Icon(Icons.language),
            onPressed: (BuildContext context) {},
          ),
        ],
      ),
      SettingsSection(
        title: 'Other Settings',
        tiles: [
          SettingsTile(
            title: 'Logout',
            //subtitle: 'English',
            leading: Icon(Icons.language),
            onPressed: (BuildContext context) {
              // Logout User
              logoutCurrentUser();
              // Show loginScreen
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    // show loginScreen
                    DefaultTabController(length: 2, child: LoginScreen()),
              ));
            },
          ),
        ],
      ),
    ],
  );
}

void logoutCurrentUser() async {
  ParseUser currentUser = await ParseUser.currentUser();
  var response = await currentUser.logout();

  if (!response.success) {
    print('Something went wrong while logging user out!');
  }
}
