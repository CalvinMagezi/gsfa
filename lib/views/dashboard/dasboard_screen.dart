import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_gosoft/providers/user_provider.dart';
import 'package:mobile_gosoft/views/%20notifications/notifications_screen.dart';
import 'package:mobile_gosoft/widgets/dashboard/navigation_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;
  num? _usage;

  @override
  void initState() {
    super.initState();
    _fetchMeterDetails();
  }

  Future<void> _fetchMeterDetails() async {
    final userDetailsProvider =
        Provider.of<UserProvider>(context, listen: false);
    final user = userDetailsProvider.user;
    final url = Uri.parse(
        'http://146.190.154.56:5000/api/v1/meter?customer_id=${user?.id}');
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url);
      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('returned_resultset')) {
        final returnedResultset = responseBody['returned_resultset'][0];
        final meterId = returnedResultset['id'];
        final meterNumber = returnedResultset['_identifier'];

        final userUpdate = User(
          id: user?.id,
          firstName: user?.firstName,
          lastName: user?.lastName,
          email: user?.email,
          createdAt: user?.createdAt,
          updatedAt: user?.updatedAt,
          meter_number: meterNumber,
          meter_id: meterId,
          userId: user?.userId,
        );
        userDetailsProvider.setUser(userUpdate);

        // Fetch usage details
        final usageUrl = Uri.parse(
            'http://146.190.154.56:5000/api/v1/usage?meter_id=${meterId}');
        final usageResponse = await http.get(usageUrl);
        final usageResponseBody = jsonDecode(usageResponse.body);
        if (usageResponseBody.containsKey('consumption')) {
          final returnedResultset = usageResponseBody['consumption'];
          final usage = returnedResultset;
          // print(usage);
          setState(() {
            _usage = usage;
          });
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserProvider>(context);
    final user = userDetailsProvider.user;
    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM').format(now);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      radius: 30.0,
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      'Hi, ${user?.firstName}',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Icon(PhosphorIcons.light.bell, color: Colors.black),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: const Color(0xffE5E7EB)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Text(
                      "Meter number",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        user?.meter_number ?? "",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: MediaQuery.of(context).size.width - 32.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xff9747ff),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_usage?.toStringAsFixed(3) ?? '0.000'} m3",
                      style: TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Consumption since installation",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/meter-information');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View $currentMonth Consumption',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff175CD3),
                    ),
                  ),
                  Icon(
                    PhosphorIcons.light.caretRight,
                    color: Color(0xff175CD3),
                    size: 24.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Column(
              children: [
                NavigationCard(
                  icon: PhosphorIcons.light.chartBar,
                  title: "Consumption history",
                  route: "/consumption-history",
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1.0,
                  height: 16.0,
                  indent: 48.0,
                  endIndent: 16.0,
                ),
                NavigationCard(
                  icon: PhosphorIcons.light.receipt,
                  title: "Invoices",
                  route: "/invoices",
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1.0,
                  height: 16.0,
                  indent: 48.0,
                  endIndent: 16.0,
                ),
                NavigationCard(
                  icon: PhosphorIcons.light.gearSix,
                  title: "Settings",
                  route: "/settings",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
