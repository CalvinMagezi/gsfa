import 'package:flutter/material.dart';
import 'package:mobile_gosoft/providers/user_provider.dart';

import 'package:mobile_gosoft/views/onboarding_screen.dart';
import 'package:mobile_gosoft/views/settings/account/account_settings_screen.dart';
import 'package:mobile_gosoft/views/settings/notifications/notifications_setting_screen.dart';
import 'package:mobile_gosoft/views/settings/support/support_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            PhosphorIcons.light.arrowLeft,
            size: 40,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Expanded(
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  'Account',
                  Icon(PhosphorIcons.light.caretRight),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountSettingsScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1.0, color: Colors.grey),
                _buildMenuItem(
                  context,
                  'Notifications',
                  Icon(PhosphorIcons.light.caretRight),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsSettingsScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1.0, color: Colors.grey),
                _buildMenuItem(
                  context,
                  'Support',
                  Icon(PhosphorIcons.light.caretRight),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupportScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1.0, color: Colors.grey),
                _buildMenuItem(
                  context,
                  'Sign Out',
                  null,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Sign Out'),
                          content: Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Sign Out'),
                              onPressed: () {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .resetUser();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OnboardingScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    Widget? trailing, {
    VoidCallback? onPressed,
  }) {
    if (trailing == null) {
      return ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onPressed,
      );
    } else {
      return InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              trailing,
            ],
          ),
        ),
      );
    }
  }
}
