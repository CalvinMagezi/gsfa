import 'package:flutter/material.dart';
import 'package:mobile_gosoft/views/%20notifications/notification_info_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

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
          "Notifications",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationInfoScreen(
                    status: 'Overdue',
                    date: 'Due: May 2023',
                    message:
                        'Hi John, your payment for May 2023 is overdue. Please make the payment as soon as possible.',
                  ),
                ),
              );
            },
            child: _buildNotificationItem(
              'Due: May 2023',
              'Hi John, your payment for May 2023 is overdue. Please make the payment as soon as possible.',
              '28 May',
              true,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationInfoScreen(
                    status: 'Due',
                    date: 'Due: June 2023',
                    message: 'Hi John, your payment for June 2023 is due.',
                  ),
                ),
              );
            },
            child: _buildNotificationItem(
              'Due: June 2023',
              'Hi John, your payment for June 2023 is due.',
              '',
              false,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationInfoScreen(
                    status: 'Due',
                    date: 'Due: July 2023',
                    message: 'Hi John, your payment for July 2023 is due.',
                  ),
                ),
              );
            },
            child: _buildNotificationItem(
              'Due: July 2023',
              'Hi John, your payment for July 2023 is due.',
              '',
              false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      String dueDate, String message, String date, bool overdue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          overdue
              ? Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.only(top: 8.0, right: 8.0),
                )
              : SizedBox(width: 18.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dueDate,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            date,
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
