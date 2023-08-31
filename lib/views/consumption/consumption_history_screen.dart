import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_gosoft/providers/user_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ConsumptionHistoryScreen extends StatefulWidget {
  const ConsumptionHistoryScreen({Key? key}) : super(key: key);

  @override
  _ConsumptionHistoryScreenState createState() =>
      _ConsumptionHistoryScreenState();
}

class _ConsumptionHistoryScreenState extends State<ConsumptionHistoryScreen> {
  late List<UsageData> _data;
  bool _isLoading = false;
  bool _hasError = false;

  _ConsumptionHistoryScreenState() {
    _data = [];
  }

  @override
  void initState() {
    super.initState();
    _fetchUsageDetails();
  }

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
          "Consumption History",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Text(
                    'An error occurred while fetching data.',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : _data.isEmpty
                  ? Center(
                      child: Text(
                        'No data available.',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(height: 16.0),
                        Expanded(
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            series: <ColumnSeries<UsageData, String>>[
                              ColumnSeries<UsageData, String>(
                                dataSource: _data,
                                xValueMapper: (UsageData usage, _) =>
                                    usage.month,
                                yValueMapper: (UsageData usage, _) =>
                                    usage.usage,
                                color: Color(0xFF9747FF),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 32.0),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: _data.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 16.0),
                            itemBuilder: (context, index) {
                              final usage = _data[index];
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${usage.month} ${usage.year}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${usage.usage.toStringAsFixed(3)} m3',
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
                          ),
                        ),
                      ],
                    ),
    );
  }

  Future<void> _fetchUsageDetails() async {
    final userDetailsProvider =
        Provider.of<UserProvider>(context, listen: false);
    final user = userDetailsProvider.user;
    final url = Uri.parse(
        'http://146.190.154.56:5000/api/v1/usage?meter_id=${user?.meter_id}');
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url);
      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('returned_resultset')) {
        final returnedResultset = responseBody['returned_resultset'];
        final data = returnedResultset
            .map((result) => UsageData(
                  result['month'],
                  result['usage'],
                  result['year'],
                ))
            .toList()
            .cast<UsageData>();

        // print(data);

        setState(() {
          _data = data;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class UsageData {
  UsageData(this.month, this.usage, this.year);

  final String month;
  final num usage;
  final String year;
}
