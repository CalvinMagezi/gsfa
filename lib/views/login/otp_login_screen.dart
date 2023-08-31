import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_gosoft/providers/user_provider.dart';
import 'package:mobile_gosoft/views/dashboard/dasboard_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class OtpLoginScreen extends StatefulWidget {
  final String phone_number;

  const OtpLoginScreen({Key? key, required this.phone_number})
      : super(key: key);

  @override
  _OtpLoginScreenState createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _digit4Controller = TextEditingController();

  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _digit1Controller.addListener(_onTextChanged);
    _digit2Controller.addListener(_onTextChanged);
    _digit3Controller.addListener(_onTextChanged);
    _digit4Controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _digit1Controller.dispose();
    _digit2Controller.dispose();
    _digit3Controller.dispose();
    _digit4Controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isButtonEnabled = _digit1Controller.text.isNotEmpty &&
          _digit2Controller.text.isNotEmpty &&
          _digit3Controller.text.isNotEmpty &&
          _digit4Controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.light.arrowLeft,
              color: Colors.black, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter the 4-digit code sent to your phone number ${widget.phone_number}.",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpTextField(_digit1Controller),
                    _buildOtpTextField(_digit2Controller),
                    _buildOtpTextField(_digit3Controller),
                    _buildOtpTextField(_digit4Controller),
                  ],
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 64.0),
              ],
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
            Positioned(
              bottom: 32.0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _isButtonEnabled
                          ? _onLoginPressed
                          : null,
                  child: Text("Log in"),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpTextField(TextEditingController controller) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onLoginPressed() async {
    final phone_number = widget.phone_number;
    final otp = _digit1Controller.text +
        _digit2Controller.text +
        _digit3Controller.text +
        _digit4Controller.text;

    final url = Uri.parse(
        'http://146.190.154.56:5000/api/v1/customer?phone_number=$phone_number');
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url);

      print(response.body);

      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('returned_resultset')) {
        final userDetailsProvider =
            Provider.of<UserProvider>(context, listen: false);
        final returnedResultset = responseBody['returned_resultset'];
        final id = returnedResultset['id'] ?? "";
        final firstName = returnedResultset['first_name'] ?? "";
        final lastName = returnedResultset['last_name'] ?? "";
        final email = returnedResultset['email'] ?? "";
        final createdAt = returnedResultset['created_at'] ?? "";
        final updatedAt = returnedResultset['updated_at'] ?? "";
        final meter_number = "";
        final meter_id = "";
        final userId = returnedResultset['user_id'] ?? "";

        final user = User(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          createdAt: createdAt,
          updatedAt: updatedAt,
          meter_number: meter_number,
          meter_id: meter_id,
          userId: userId,
        );
        userDetailsProvider.setUser(user);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      } else {
        // Handle error response
        final error = responseBody['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
      // Handle exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
