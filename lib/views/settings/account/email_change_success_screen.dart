import 'package:flutter/material.dart';
import 'package:mobile_gosoft/views/dashboard/dasboard_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EmailChangeSuccessScreen extends StatelessWidget {
  const EmailChangeSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            PhosphorIcons.light.arrowLeft,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.light.checkCircle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 32.0),
            Text(
              "Please check you new email inbox to confirm your new email address.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 64.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
                },
                child: Text("Open email"),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff1570ef),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
