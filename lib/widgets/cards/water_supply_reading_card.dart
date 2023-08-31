import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterSupplyReadingCard extends StatefulWidget {
  final num total;

  const WaterSupplyReadingCard({Key? key, required this.total})
      : super(key: key);

  @override
  _WaterSupplyReadingCardState createState() => _WaterSupplyReadingCardState();
}

class _WaterSupplyReadingCardState extends State<WaterSupplyReadingCard> {
  DateTime? _selectedDate;
  num _waterUsage = 0.0;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM').format(now);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Amount consumed in ${currentMonth}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        "${_waterUsage.toStringAsFixed(1)} m3",
                        style: TextStyle(
                          fontSize: 48.0,
                          color: Color(0xff9747FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedDate == null
                      ? "Read at ${DateFormat('dd/MM/yyyy \'at\' h:mma').format(DateTime.now())}"
                      : "Read at ${DateFormat('dd/MM/yyyy \'at\' h:mma').format(_selectedDate!)}",
                  style: TextStyle(
                    color: Color(0xff4B5563),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
