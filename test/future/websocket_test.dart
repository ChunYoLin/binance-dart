import 'package:test/test.dart';

import '../../lib/binance.dart';

void main() {
  final fwebsocket = BinanceFuture();

  test('aggTrade', () async {
    final stream = await fwebsocket.aggTrade('BTCUSDT');

    stream.first.then(expectAsync1((e) {
      expect(e.eventType, equals('aggTrade'));
      expect(e.eventTime, isNotNull);
      expect(e.id, isNotNull);
    }));
  });

  test('allMarkPrice', () async {
    final stream = await fwebsocket.allMarkPrice();

    stream.first.then(expectAsync1((e) {
      expect(e.first.eventType, equals('markPriceUpdate'));
      expect(e.first.eventTime, isNotNull);
      expect(e.first.symbol, isNotNull);
    }));
  });
}
