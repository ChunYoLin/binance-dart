import 'package:test/test.dart';

import '../../lib/binance.dart';

void main() {
  final fwebsocket = BinanceFuture();

  test('allBookTicker', () async {
    final stream = await fwebsocket.allBookTicker();

    stream.first.then(expectAsync1((e) {
      expect(e.updateID, isNotNull);
      expect(e.askPrice, isNotNull);
      expect(e.bidQty, isNotNull);
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
