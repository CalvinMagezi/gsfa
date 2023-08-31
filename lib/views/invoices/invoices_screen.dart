import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_gosoft/providers/user_provider.dart';
import 'package:mobile_gosoft/views/invoices/invoice_details_screen.dart';
import 'package:mobile_gosoft/widgets/cards/invoice_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class InvoicesScreen extends StatefulWidget {
  InvoicesScreen({Key? key}) : super(key: key);

  @override
  _InvoicesScreenState createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  List<Map<String, dynamic>> _invoices = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  Future<void> _fetchInvoices() async {
    final userDetailsProvider =
        Provider.of<UserProvider>(context, listen: false);
    final user = userDetailsProvider.user;
    final url = Uri.parse(
        'http://146.190.154.56:5000/api/v1/invoice?meter_id=${user?.meter_id}');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await http.get(url);
      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('returned_resultset')) {
        final returnedResultset = responseBody['returned_resultset'];
        final data = returnedResultset
            .map((result) => {
                  'id': result['id'],
                  'monthYear': result['date'],
                  'amount': result['total_amount'].toString(),
                  'status': 'Paid',
                })
            .toList()
            .cast<Map<String, dynamic>>();
        setState(() {
          _invoices = data;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch invoices';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          "Invoices",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!),
                )
              : ListView.builder(
                  itemCount: _invoices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoiceDetailsScreen(
                              monthYear: _invoices[index]['monthYear'],
                              amount: _invoices[index]['amount'],
                              status: _invoices[index]['status'],
                              dueDate: _invoices[index]['monthYear'],
                              id: _invoices[index]['id'],
                            ),
                          ),
                        );
                      },
                      child: InvoiceCard(
                        monthYear: _invoices[index]['monthYear'],
                        amount: _invoices[index]['amount'],
                        status: _invoices[index]['status'],
                      ),
                    );
                  },
                ),
    );
  }
}
