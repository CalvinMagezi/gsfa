import 'package:flutter/material.dart';
import 'package:mobile_gosoft/views/settings/account/change_email_otp_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.light.arrowLeft),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Change email",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current email',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    _buildDetailRow('Email', 'john.doe@example.com'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'New email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailOtpScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1570EF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                'Send verification code',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
