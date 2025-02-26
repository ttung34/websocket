import 'package:flutter/material.dart';
import 'package:flutter_websocket/work/work_detail.dart';
import 'package:flutter_websocket/models/work_model.dart';

class WorkFrom extends StatelessWidget {
  const WorkFrom({required this.dataWorkModel, super.key});

  final WorkModel dataWorkModel;

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour}: ${date.minute} :${date.second} ${date.day}/${date.month}/${date.year}';
  }

  Color _getPMColor(double value) {
    if (value <= 12) return Colors.green;
    if (value <= 35) return const Color.fromARGB(255, 212, 192, 6);
    if (value <= 55) return Colors.orange;
    if (value <= 150) return Colors.red;
    if (value > 150) return Colors.purple;
    return Colors.red;
  }

  Widget _buildPMValue(String label, double? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: '),
          Text(
            value != null ? '${value.toStringAsFixed(1)} cm' : 'N/A',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getPMColor(value ?? 0),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WorkDetail(workDatilModel: dataWorkModel)));
      },
      child: Card(
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
                    'location: ${dataWorkModel.location ?? "Unknonw"}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'ID: ${dataWorkModel.device_id ?? "Unknown"}',
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text('Timestamp: ${dataWorkModel.timestamp}'),
              Text('Time: ${_formatTimestamp(dataWorkModel.timestamp)}'),
              if (dataWorkModel.values != null) ...[
                const Divider(),
                _buildPMValue('PM 1.0', dataWorkModel.values!['pm1_0']),
                _buildPMValue('PM 2.5', dataWorkModel.values!['pm2_5']),
                _buildPMValue('PM 10.0', dataWorkModel.values!['pm10_0']),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
