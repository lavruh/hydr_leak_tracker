import 'package:flutter/material.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:intl/intl.dart';

class LogEntryWidget extends StatelessWidget {
  const LogEntryWidget({Key? key, required this.entry, required this.onTap})
      : super(key: key);
  final LogEntry entry;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 200, child: Text(DateFormat('y-MM-dd \t HH:mm').format(entry.date))),
            SizedBox(width: 200, child: Text(entry.volume.toString())),
            SizedBox(width: 200, child: Text(entry.operation.name)),
            SizedBox(width: 400,child: Text(entry.remark)),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
