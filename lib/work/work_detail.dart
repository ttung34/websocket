import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_websocket/models/work_model.dart';

class WorkDetail extends StatelessWidget {
  const WorkDetail({required this.workDatilModel, super.key});

  final WorkModel workDatilModel;

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour}: ${date.minute} :${date.second} ${date.day}/${date.month}/${date.year}';
  }

  double _getMaxValue() {
    return workDatilModel.values!.values
        .reduce((max, value) => max > value ? max : value);
  }

  Color _getColor(double value) {
    if (value <= 12) return Colors.green;
    if (value <= 35) return const Color.fromARGB(255, 212, 192, 6);
    if (value <= 55) return Colors.orange;
    if (value <= 150) return Colors.red;
    if (value > 150) return Colors.purple;
    return Colors.red;
  }

  List<BarChartGroupData> _createBarGroup() {
    return workDatilModel.values!.entries.map((entry) {
      return BarChartGroupData(
        x: workDatilModel.values!.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: _getColor(entry.value),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Work"),
      ),
      body: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'location: ${workDatilModel.location ?? "Unknonw"}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Timestamp: ${workDatilModel.timestamp ?? "Unknown"}',
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text('Time: ${_formatTimestamp(workDatilModel.timestamp)}'),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 150,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String key =
                              workDatilModel.values!.keys.elementAt(groupIndex);
                          return BarTooltipItem(
                            '$key\n',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${workDatilModel.values![key]?.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: _getColor(
                                      workDatilModel.values![key] ?? 0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >=
                                workDatilModel.values!.length) {
                              return const Text('');
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  workDatilModel.values!.keys
                                      .elementAt(value.toInt()),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(1),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _createBarGroup(),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: false,
                      horizontalInterval: _getMaxValue() / 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Biểu đồ thể hiệ chỉ số của Hà Nội',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
