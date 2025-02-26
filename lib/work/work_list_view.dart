import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_websocket/config/config.dart';
import 'package:flutter_websocket/work/work_from.dart';
import 'package:flutter_websocket/models/work_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WorkListView extends StatefulWidget {
  const WorkListView({super.key});

  @override
  State<WorkListView> createState() => _WorkListViewState();
}

class _WorkListViewState extends State<WorkListView> {
  // final WebSocketService _webSocketService = WebSocketService();
  late WebSocketChannel _channel;
  final List<WorkModel> _dataList = [];
  bool _isConnected = false;
  bool _dispose = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(EnvConfig.apiRealTime));
      setState(() {
        _isConnected = true;
        _errorMessage = null;
      });
      _channel.stream.listen(
        (data) {
          _handelData(data);
        },
        onError: (error) {
          print('WebSocket error: $error');
          setState(() {
            _isConnected = false;
            _errorMessage = 'Connection error: $error';
          });
        },
        onDone: () {
          print('WebSocket connection closed');
          setState(() {
            _isConnected = false;
            _errorMessage = 'Connection closed';
          });
        },
      );
    } catch (e) {
      print('Failed to connect: $e');
      setState(() {
        _isConnected = false;
        _errorMessage = 'Failed to connect: $e';
      });
    }
  }

  void _handelData(dynamic data) {
    if (_dispose) return;
    try {
      print("Received raw data: $data");
      Map<String, dynamic> jsonData;
      if (data is String) {
        jsonData = jsonDecode(data);
      } else if (data is Map) {
        jsonData = Map<String, dynamic>.from(data);
      } else {
        throw FormatException('Unexpected data format: ${data.runtimeType}');
      }
      final workModel = WorkModel.fromJson(jsonData);
      print('Parsed workModel: $workModel');
      if (mounted) {
        setState(() {
          if (_dataList.length >= 100) {
            _dataList.removeAt(0);
          }
          _dataList.add(workModel);
          _errorMessage = null;
        });
      }
    } catch (e, stackTrace) {
      print("Error handling data: $e");
      print("Stack trace: $stackTrace");
      setState(() {
        _errorMessage = 'Error processing data: $e';
      });
    }
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work List'),
        actions: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                _isConnected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  color: _isConnected ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(_errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _connectWebSocket,
                    child: const Text("Retry connections"),
                  )
                ],
              ),
            )
          : _dataList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() => _dataList.clear());
                    _connectWebSocket();
                  },
                  child: ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      final data = _dataList[_dataList.length - 1 - index];
                      return WorkFrom(dataWorkModel: data);
                    },
                  ),
                ),
    );
  }
}
