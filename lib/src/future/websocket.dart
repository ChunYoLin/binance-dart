import 'dart:convert' as convert;
import 'package:web_socket_channel/io.dart';

import '../../data/future_classes.dart';
import '../../data/ws_classes.dart';

class BinanceFutureWebsocket {
  IOWebSocketChannel _public(String channel) => IOWebSocketChannel.connect(
        'wss://fstream.binance.com/ws/${channel}',
        pingInterval: Duration(minutes: 1),
      );

  Map _toMap(json) => convert.jsonDecode(json);
  List<Map> _toList(json) => List<Map>.from(convert.jsonDecode(json));

  /// Reports 24hr miniTicker events every second from <symbol>@miniTicker
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/web-socket-streams.md#individual-symbol-mini-ticker-stream

  Stream<WSBookTicker> allBookTicker() {
    final channel = _public("!bookTicker");

    return channel.stream.map<Map>(_toMap).map((m) => WSBookTicker.fromMap(m));
  }

  Stream<List<MarkPrice>> allMarkPrice() {
    final channel = _public("!markPrice@arr");

    return channel.stream.map<List<Map>>(_toList).map<List<MarkPrice>>(
        (l) => l.map((m) => MarkPrice.fromMap(m)).toList());
  }
}
