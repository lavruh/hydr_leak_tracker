import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/log.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/domain/separated_log_providers.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';
import 'package:intl/intl.dart';

class GraphicWidget extends ConsumerWidget {
  const GraphicWidget({Key? key, this.onTapValue}) : super(key: key);

  final Function(int val)? onTapValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(logProvider);
    if (data.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LineChart(
        LineChartData(
            lineBarsData: [
              _chartData(ref, emptyEntriesColor, ShipOperation.empty),
              _chartData(ref, loadedEntriesColor, ShipOperation.loaded),
              _chartData(ref, dredgingEntriesColor, ShipOperation.dredging),
              _chartData(
                  ref, dischargingEntriesColor, ShipOperation.discharging),
            ],
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitleWidgets,
              )),
            ),
            lineTouchData: LineTouchData(touchCallback: (event, resp) {
              if (event is FlTapDownEvent) {
                final dateVal = resp?.lineBarSpots?.first.x;
                if (dateVal != null) {
                  if (onTapValue != null) {
                    onTapValue!(dateVal.toInt());
                  }
                }
              }
            })),
      ),
    );
  }

  Widget bottomTitleWidgets(double millisecondsSinceEpoch, TitleMeta meta) {
    final ms = millisecondsSinceEpoch.toInt();
    final date = DateTime.fromMillisecondsSinceEpoch(ms);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      angle: math.pi / 4,
      child: Text(
        DateFormat('d-MM').format(date),
      ),
    );
  }

  LineChartBarData _chartData(
      WidgetRef ref,
      StateNotifierProvider<SettingNotifier<int>, int> provider,
      ShipOperation operation) {
    return LineChartBarData(
      color: Color(ref.watch(provider)),
      barWidth: 3,
      isCurved: true,
      curveSmoothness: 0.2,
      spots: ref
          .watch(filteredByOperationLogProvider(operation))
          .map(
              (e) => FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.volume))
          .toList(),
    );
  }
}
