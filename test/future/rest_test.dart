import 'package:test/test.dart';

import 'package:binance/binance.dart';

void main() {
  final rest = BinanceFuture();

  test('ping', () async {
    final result = await rest.ping();
    expect(result, equals(true));
  });

  test('time', () async {
    final serverTime = await rest.time();
    final now = DateTime.now();
    final tolerance = Duration(minutes: 1);

    expect(serverTime.difference(now), lessThan(tolerance));
  });

  test('exchangeInfo', () async {
    final result = await rest.exchangeInfo();

    final serverTime = result.serverTime;
    final now = DateTime.now();
    final tolerance = Duration(minutes: 1);
    print(result);

    expect(serverTime.difference(now), lessThan(tolerance));

    expect(result.symbols.length, greaterThan(50));
  });

  test('depth', () async {
    final result = await rest.depth('BTCUSDT', 100);

    expect(result.lastUpdateId, isNotNull);
    expect(result.bids.length, equals(100));
    expect(result.asks.length, equals(100));
  });

  test('recentTrades', () async {
    final result = await rest.recentTrades('BTCUSDT', 100);

    expect(result.length, equals(100));
    expect(result.first.id, isNotNull);
    expect(result.first.isBuyerMaker, isNotNull);
    expect(result.first.price, isNotNull);
    expect(result.first.qty, isNotNull);
    expect(result.first.time, isNotNull);
  });

  test('aggregatedTrades', () async {
    final result = await rest.aggregatedTrades(
      'BTCUSDT',
      limit: 100,
      startTime: DateTime.now().subtract(Duration(minutes: 10)),
      endTime: DateTime.now(),
    );

    expect(result.length, equals(100));
    expect(result.first.id, isNotNull);
    expect(result.first.isBuyerMaker, isNotNull);
    expect(result.first.price, isNotNull);
    expect(result.first.qty, isNotNull);
    expect(result.first.time, isNotNull);
  });

  test('candlesticks', () async {
    final result = await rest.candlesticks(
      'BTCUSDT',
      Interval.oneMinute,
      limit: 100,
    );

    expect(result.length, equals(100));
    expect(result.first.open, isNotNull);
    expect(result.first.high, isNotNull);
    expect(result.first.low, isNotNull);
    expect(result.first.close, isNotNull);
  });

  test('symbolPriceTicker', () async {
    final result = await rest.symbolPriceTicker('BTCUSDT');

    expect(result.symbol, equals('BTCUSDT'));
    expect(result.price, isNotNull);
  });

  test('allSymbolPriceTickers', () async {
    final result = await rest.allSymbolPriceTickers();

    expect(result.length, greaterThan(50));
    expect(result.first.symbol, isNotNull);
    expect(result.first.price, isNotNull);
  });

  test('bookTicker', () async {
    final result = await rest.bookTicker('BTCUSDT');

    expect(result.symbol, equals('BTCUSDT'));
    expect(result.bidPrice, isNotNull);
  });

  test('allBookTickers', () async {
    final result = await rest.allBookTickers();

    expect(result.length, greaterThan(50));
    expect(result.first.symbol, isNotNull);
    expect(result.first.bidPrice, isNotNull);
  });
}
