import 'package:flutter/material.dart';
import 'location_screen.dart';

class AttendanceScreen extends StatelessWidget {
  final List<Map<String, String>> members = [
    {'name': 'John Doe', 'id': '1'},
    {'name': 'Jane Smith', 'id': '2'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(members[index]['name']!),
            subtitle: Text('ID: ${members[index]['id']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Edit functionality coming soon!')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.map),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationScreen(
                          memberName: members[index]['name']!,
                          memberId: members[index]['id']!,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
