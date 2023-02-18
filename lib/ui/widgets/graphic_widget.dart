import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/log.dart';
import 'package:hydr_leak_tracker/domain/log_analyse_provider.dart';
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
              _chartData(ref, ShipOperation.empty),
              _chartData(ref, ShipOperation.loaded),
              _chartData(ref, ShipOperation.dredging),
              _chartData(ref, ShipOperation.discharging),
              _trendLineData(ref, ShipOperation.empty),
              _trendLineData(ref, ShipOperation.loaded),
              _trendLineData(ref, ShipOperation.dredging),
              _trendLineData(ref, ShipOperation.discharging),
            ],
            titlesData: FlTitlesData(
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitleWidgets))),
            lineTouchData: LineTouchData(
              touchCallback: (event, resp) {
                if (event is FlTapDownEvent) {
                  final dateVal = resp?.lineBarSpots?.first.x;
                  if (dateVal != null) {
                    if (onTapValue != null) {
                      onTapValue!(dateVal.toInt());
                    }
                  }
                }
              },
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                getTooltipItems: (data) {
                  return data.map((e) {
                    String data = e.y.toString();
                    final spots = e.bar.spots;
                    final isNotTrendLine = e.bar.barWidth > 2;
                    if (isNotTrendLine) {
                      if (e.spotIndex > 0) {
                        final delta = LogAnalyse.spotsDelta(
                            spots[e.spotIndex - 1], spots[e.spotIndex]);
                        data += ' \n ∆$delta';
                      }
                      if (e.spotIndex == spots.length - 1) {
                        final averageLoses = LogAnalyse.average(
                            LogAnalyse.calcLosesPerEntry(spots));
                        data += "\n Average ∆ ${averageLoses.value}";
                      }
                    } else {
                      data = 'Average $data';
                    }

                    return LineTooltipItem(data, TextStyle(color: e.bar.color));
                  }).toList();
                },
              ),
            )),
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
    ShipOperation operation,
  ) {
    return LineChartBarData(
      color: _getColorOfOperation(ref, operation),
      barWidth: 3,
      isCurved: true,
      curveSmoothness: 0.2,
      spots: ref
          .watch(filteredByOperationLogProvider(operation))
          .reversed
          .map((e) => FlSpot(_dateToAxisValue(e.date), e.volume))
          .toList(),
    );
  }

  LineChartBarData _trendLineData(WidgetRef ref, ShipOperation operation) {
    final data = ref.watch(filteredByOperationLogProvider(operation));
    List<FlSpot> points = [];
    if (data.length > 1) {
      final average = LogAnalyse.average(data);
      points = [
        FlSpot(_dateToAxisValue(data.last.date), data.last.volume),
        FlSpot(_dateToAxisValue(average.date), average.value),
      ];
    }
    return LineChartBarData(
      color: _getColorOfOperation(ref, operation),
      barWidth: 1,
      isStrokeCapRound: false,
      isStrokeJoinRound: false,
      spots: points,
    );
  }

  static Color _getColorOfOperation(
    WidgetRef ref,
    ShipOperation operation,
  ) {
    if (operation == ShipOperation.loaded) {
      return Color(ref.watch(loadedEntriesColor));
    }
    if (operation == ShipOperation.empty) {
      return Color(ref.watch(emptyEntriesColor));
    }
    if (operation == ShipOperation.dredging) {
      return Color(ref.watch(dredgingEntriesColor));
    }
    if (operation == ShipOperation.discharging) {
      return Color(ref.watch(dischargingEntriesColor));
    }
    return Colors.black;
  }

  static double _dateToAxisValue(DateTime date) =>
      date.millisecondsSinceEpoch.toDouble();
}
