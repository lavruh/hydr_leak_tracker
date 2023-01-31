class LogEntry {
  final String id;
  final DateTime date;
  final int sounding;
  final double volume;
  final String remark;
  final ShipOperation operation;

  LogEntry({
    required this.id,
    required this.date,
    required this.sounding,
    required this.volume,
    required this.remark,
    required this.operation,
  });

  LogEntry.now({
    required this.sounding,
    required this.volume,
    required this.remark,
    required this.operation,
  })  : date = DateTime.now(),
        id = generateId();

  LogEntry copyWith({
    String? id,
    DateTime? date,
    int? sounding,
    double? volume,
    String? remark,
    ShipOperation? operation,
  }) {
    return LogEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      sounding: sounding ?? this.sounding,
      volume: volume ?? this.volume,
      remark: remark ?? this.remark,
      operation: operation ?? this.operation,
    );
  }

  static String generateId() =>
      DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'sounding': sounding,
      'volume': volume,
      'remark': remark,
      'operation': operation.index,
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'] as String,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : throw Exception('Invalid data: LogEntry <date> -> ${map['date']}'),
      sounding: map['sounding'] as int,
      volume: map['volume'] as double,
      remark: map['remark'] as String,
      operation: map['operation'] != null
          ? ShipOperation.values[map['operation']]
          : throw Exception(
              'Invalid data: LogEntry <operation> -> ${map['operation']}'),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date.millisecondsSinceEpoch == other.date.millisecondsSinceEpoch &&
          sounding == other.sounding &&
          volume == other.volume &&
          remark == other.remark &&
          operation == other.operation;

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      sounding.hashCode ^
      volume.hashCode ^
      remark.hashCode ^
      operation.hashCode;

  @override
  String toString() {
    return 'LogEntry{id: $id, date: $date, sounding: $sounding, volume: $volume, remark: $remark, operation: $operation}';
  }
}

enum ShipOperation { loaded, empty, dredging, discharging }
