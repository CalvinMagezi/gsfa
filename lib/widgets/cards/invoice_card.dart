import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final String monthYear;
  final String amount;
  final String? status;

  const InvoiceCard({
    Key? key,
    required this.monthYear,
    required this.amount,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color tagColor;
    Color tagTextColor;
    switch (status) {
      case 'Not paid':
        tagColor = Color(0xffFEE4E2);
        tagTextColor = Color(0xffF04438);
        break;
      case 'Partially paid':
        tagColor = Color(0xffFCEFCF);
        tagTextColor = Color(0xffF59E0B);
        break;
      case 'Paid':
        tagColor = Color(0xffE3FCEF);
        tagTextColor = Color(0xff12B76A);
        break;
      default:
        tagColor = Colors.transparent;
        tagTextColor = Colors.black;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: Border(
        bottom: BorderSide(
          color: Color(0xffEEEEEE),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthYear,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    status?.isEmpty ?? true ? "Paid" : status!,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: tagTextColor,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'KES $amount',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
