import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile_gosoft/views/invoices/payment_instructions_screen.dart';
import 'package:mobile_gosoft/widgets/lists/bill_breakdown_list.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final String monthYear;
  final String amount;
  final String status;
  final String dueDate;
  final String id;

  const InvoiceDetailsScreen({
    Key? key,
    required this.monthYear,
    required this.amount,
    required this.status,
    required this.dueDate,
    required this.id,
  }) : super(key: key);

  @override
  _InvoiceDetailsScreenState createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  Color statusColor = Colors.grey;
  Future<Map<String, dynamic>>? invoiceDetails;

  @override
  void initState() {
    super.initState();
    invoiceDetails = fetchInvoiceDetails(widget.id);
    // Initialize statusColor based on widget.status
    switch (widget.status) {
      case 'Not paid':
        statusColor = Colors.red;
        break;
      case 'Partially paid':
        statusColor = Colors.orange;
        break;
      case 'Paid':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }
  }

  Future<Map<String, dynamic>> fetchInvoiceDetails(String id) async {
    final response = await http
        .get(Uri.parse('http://146.190.154.56:5000/api/v1/invoice/$id'));

    if (response.statusCode == 200) {
      // print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load invoice details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: invoiceDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
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
                  "Invoice Details",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    widget.status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Due date',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  snapshot.data?['returned_resultset'][0]
                                      ['due_date'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Invoice details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        children: [
                          _buildDetailItem(
                              'Invoice number',
                              snapshot.data?['returned_resultset'][0]
                                  ['invoice_number']),
                          _buildDetailItem(
                              'Invoice date',
                              snapshot.data?['returned_resultset'][0]
                                  ['invoice_date']),
                          _buildDetailItem(
                              'Invoice period',
                              snapshot.data?['returned_resultset'][0]
                                  ['invoice_period']),
                          _buildDetailItem(
                            'Due date',
                            snapshot.data?['returned_resultset'][0]['due_date'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Customer details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        children: [
                          _buildDetailItem(
                              'Customer number',
                              snapshot.data?['returned_resultset'][1]
                                  ['customer_number']),
                          _buildDetailItem(
                              'Meter number',
                              snapshot.data?['returned_resultset'][1]
                                  ['meter_number']),
                          _buildDetailItem(
                              'Address',
                              snapshot.data?['returned_resultset'][1]
                                  ['address']),
                        ],
                      ),
                      SizedBox(height: 32.0),
                      Text(
                        'Meter readings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        children: [
                          _buildMeterReadingItems(
                            'Previous reading',
                            '28 Apr 2023',
                            snapshot.data?['returned_resultset'][2]
                                ['previous_reading'],
                          ),
                          _buildMeterReadingItems(
                            'Present reading',
                            '01 May 2023',
                            snapshot.data?['returned_resultset'][2]
                                ['present_reading'],
                          ),
                          _buildMeterReadingItems(
                            'Consumption for',
                            snapshot.data?['returned_resultset'][0]
                                ['invoice_period'],
                            snapshot.data?['returned_resultset'][2]
                                ['consumption'],
                          ),
                          _buildMeterReadingItems(
                            'Consumption billed for',
                            snapshot.data?['returned_resultset'][0]
                                ['invoice_period'],
                            snapshot.data?['returned_resultset'][2]
                                ['consumption_billed'],
                          ),
                        ],
                      ),
                      SizedBox(height: 32.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bill Breakdown',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Tarrifs',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _buildTariffsBottomSheet(
                                              context);
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Color(0xFF175CD3),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      BillBreakdownList(
                        items: [
                          {
                            'title': 'Electricity Charges',
                            'value': 'KES 500.00'
                          },
                          {'title': 'Fixed Charges', 'value': 'KES 50.00'},
                          {'title': 'Late Payment Fee', 'value': 'KES 20.00'},
                          {'title': 'VAT', 'value': 'KES 0.00'},
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Divider(
                        thickness: 1.0,
                        color: Colors.black,
                        indent: 16.0,
                        endIndent: 16.0,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Standing charges',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'KES ${snapshot.data?['returned_resultset'][3]['standing_charges']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bal. brought forward',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                'from ${widget.monthYear} bill',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'KES ${snapshot.data?['returned_resultset'][3]['balance_brought_forward']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Charges',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 22.0,
                            ),
                          ),
                          Text(
                            'KES ${snapshot.data?['returned_resultset'][3]['total_charges']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentInstructionsScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Payment Instruction',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF1570EF),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minimumSize: Size(double.infinity, 0),
                        ),
                      ),
                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeterReadingItems(String title, String date, num value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                date,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTariffsBottomSheet(BuildContext context) {
    return Container(
      height: 400.0,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            'Tariffs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Divider(
            thickness: 2.0,
            color: Colors.black,
            indent: 16.0,
            endIndent: 16.0,
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1-6 units',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        'KES 95 / unit',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
