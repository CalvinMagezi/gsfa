import 'package:flutter/material.dart';

class BillBreakdownList extends StatelessWidget {
  final List<Map<String, String>> items;

  const BillBreakdownList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => _buildBillBreakdownItem(
                item['title']!,
                item['value']!,
              ))
          .toList(),
    );
  }

  Widget _buildBillBreakdownItem(String title, String value) {
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
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
