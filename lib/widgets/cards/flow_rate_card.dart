import 'package:flutter/material.dart';

class FlowRateCard extends StatelessWidget {
  const FlowRateCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Flow rate",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "0.0 m3/sec",
              style: TextStyle(
                fontSize: 24.0,
                color: Color(0xff9747FF),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  "Last: 4:00 pm",
                  style: TextStyle(
                    color: Color(0xff4B5563),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Refresh",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
