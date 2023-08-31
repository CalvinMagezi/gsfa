import 'package:flutter/material.dart';
import 'package:mobile_gosoft/views/settings/account/change_avatar_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'change_email_screen.dart';
import 'change_names_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

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
          "Account",
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
                  'Change avatar',
                  Icon(PhosphorIcons.light.caretRight),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeAvatarScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1.0, color: Colors.grey),
                _buildMenuItem(
                  context,
                  'Change names',
                  Icon(PhosphorIcons.light.caretRight),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNamesScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1.0, color: Colors.grey),
                _buildMenuItem(
                  context,
                  'Change email address',
                  Icon(PhosphorIcons.light.caretRight),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeEmailScreen(),
                      ),
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
