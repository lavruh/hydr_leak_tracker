import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/editor_provider.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/domain/sounding_table_provider.dart';
import 'package:hydr_leak_tracker/ui/settings_screen.dart';
import 'package:hydr_leak_tracker/ui/widgets/graphic_widget.dart';
import 'package:hydr_leak_tracker/ui/widgets/log_editor_widget.dart';
import 'package:hydr_leak_tracker/ui/widgets/log_widget.dart';
import 'package:hydr_leak_tracker/domain/log_utils.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(soundingTableProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        // title: Text(Platform.operatingSystemVersion),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(editorProvider.notifier).setState(LogEntry.empty());
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) {
                  return const SettingsScreen();
                }));
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          const LogEditorWidget(),
          const Flexible(child: LogWidget()),
          Flexible(child: GraphicWidget(
            onTapValue: (val) {
              ref.read(logSelectedItemProvider.notifier).selectItem(val);
            },
          )),
        ],
      ),
    );
  }

}
