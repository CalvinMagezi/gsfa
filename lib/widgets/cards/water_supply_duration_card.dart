import 'package:flutter/material.dart';

class WaterSupplyDurationCard extends StatefulWidget {
  const WaterSupplyDurationCard({Key? key}) : super(key: key);

  @override
  _WaterSupplyDurationCardState createState() =>
      _WaterSupplyDurationCardState();
}

class _WaterSupplyDurationCardState extends State<WaterSupplyDurationCard> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

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
              "Water supply duration",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Color(0xff175CD3),
                      ),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 16.0),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "8:20 am",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          "Start",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff12B76A),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "-",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "3 hrs 20 mins",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff9747FF),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "-",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "11:40 pm",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          "Stop",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xffF04438),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
