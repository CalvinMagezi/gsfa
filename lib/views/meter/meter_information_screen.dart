import 'package:flutter/material.dart';
import 'package:mobile_gosoft/providers/user_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MeterInformationScreen extends StatefulWidget {
  const MeterInformationScreen({Key? key}) : super(key: key);

  @override
  _MeterInformationScreenState createState() => _MeterInformationScreenState();
}

class _MeterInformationScreenState extends State<MeterInformationScreen> {
  bool _isLoading = true;
  List<dynamic> _usageData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final now = DateTime.now();
    final currentMonthNumber = DateFormat('MM').format(now);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final url =
        'http://146.190.154.56:5000/api/v1/reading?meter_id=${user?.meter_id}&month=$currentMonthNumber';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _usageData = data['returned_resultset'].reversed.toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM').format(now);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final firstReading = _usageData.isEmpty ? null : _usageData.last;
    final lastReading = _usageData.isEmpty ? null : _usageData.first;
    final difference = firstReading == null || lastReading == null
        ? null
        : lastReading['accumulated_volume'] -
            firstReading['accumulated_volume'];
    final firstReadingDate = firstReading == null
        ? null
        : DateFormat('dd MMM y')
            .format(DateTime.parse(firstReading['reading_time']));
    final lastReadingDate = lastReading == null
        ? null
        : DateFormat('dd MMM y')
            .format(DateTime.parse(lastReading['reading_time']));
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "$currentMonth Consumption",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Meter number',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          '${user?.meter_number}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount consumed in $currentMonth',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  difference == null
                                      ? 'N/A'
                                      : '${difference.toStringAsFixed(3)} m3',
                                  style: TextStyle(
                                    color: Color(0xFF9747FF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  firstReadingDate == null ||
                                          lastReadingDate == null
                                      ? 'N/A'
                                      : '$firstReadingDate - $lastReadingDate',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      try {
                        return ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          reverse: false,
                          itemCount: _usageData.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.0),
                          itemBuilder: (context, index) {
                            final usage = _usageData[index];
                            final readingTime = DateFormat('d MMMM y')
                                .format(DateTime.parse(usage['reading_time']));
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      readingTime,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${usage['accumulated_volume'].toStringAsFixed(3)} m3',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Divider(
                                  color: Colors.grey[300],
                                  thickness: 1.0,
                                ),
                                SizedBox(height: 8.0),
                              ],
                            );
                          },
                        );
                      } on StateError {
                        return Center(
                          child: Text(
                            'No usage data available',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 18.0,
                            ),
                          ),
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
