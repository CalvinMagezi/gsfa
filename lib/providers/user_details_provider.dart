import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDetailsProvider with ChangeNotifier {
  final _storage = FlutterSecureStorage();
  Map<String, dynamic>? _userDetails;

  Future<void> setUserDetails(String response) async {
    final data = jsonDecode(response);
    final userDetails = data['returned_resultset'];
    final json = jsonEncode(userDetails);
    await _storage.write(key: 'userDetails', value: json);
    _userDetails = userDetails;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    if (_userDetails != null) {
      return _userDetails;
    }
    final json = await _storage.read(key: 'userDetails');
    if (json != null) {
      _userDetails = jsonDecode(json);
      notifyListeners();
    }
    return _userDetails;
  }
}
