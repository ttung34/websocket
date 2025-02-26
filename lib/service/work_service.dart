import 'package:flutter_websocket/config/config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel channel;

  void connect(String url) {
    channel = WebSocketChannel.connect(Uri.parse(EnvConfig.apiRealTime));
  }

  void disconnect() {
    channel.sink.close();
  }
}
