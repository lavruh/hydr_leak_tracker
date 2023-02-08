import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/editor_provider.dart';
import 'package:hydr_leak_tracker/domain/log.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/domain/sounding_table_provider.dart';
import 'package:hydr_leak_tracker/ui/widgets/log_editor_widget.dart';
import 'package:hydr_leak_tracker/ui/widgets/log_entry_widget.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(soundingTableProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ref.read(editorProvider.notifier).setState(LogEntry.empty());
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          const LogEditorWidget(),
          Flexible(
              child: ListView(
            children: ref
                .watch(logProvider)
                .map((e) => LogEntryWidget(
                      entry: e,
                      onTap: () {
                        ref.read(editorProvider.notifier).setState(e);
                      },
                    ))
                .toList(),
          )),
        ],
      ),
    );
  }
}
