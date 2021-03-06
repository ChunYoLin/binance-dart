import 'package:binance/data/future_classes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../data/rest_classes.dart';
import '../../data/enums.dart';
import '../exceptions.dart';

class BinanceFutureRest {
  Future<dynamic> _public(String path, [Map<String, String> params]) async {
    final uri = Uri.https('fapi.binance.com', 'fapi$path', params);
    final response = await http.get(uri);

    final result = convert.jsonDecode(response.body);

    if (result is Map) {
      if (result.containsKey("code")) {
        throw BinanceApiException(result["msg"], result["code"]);
      }
    }

    return result;
  }

  /// Return true if the server is available with /v1/ping
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#test-connectivity
  Future<bool> ping() => _public('/v1/ping').then((r) => true);

  /// Return the current server time from /v1/time
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#check-server-time
  Future<DateTime> time() => _public('/v1/time')
      .then((r) => DateTime.fromMillisecondsSinceEpoch(r['serverTime']));

  /// Returns general info about the exchange from /v1/exchangeInfo
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#exchange-information
  Future<ExchangeInfo> exchangeInfo() =>
      _public('/v1/exchangeInfo').then((r) => ExchangeInfo.fromMap(r));

  /// Order book depth from /v1/depth
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#order-book
  Future<BookDepth> depth(String symbol, [int limit = 100]) =>
      _public('/v1/depth', {'symbol': '$symbol', 'limit': '$limit'})
          .then((r) => BookDepth.fromMap(r));

  /// Recent trades from /v1/trades
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#recent-trades-list
  Future<List<Trade>> recentTrades(String symbol, [int limit = 500]) =>
      _public('/v1/trades', {'symbol': '$symbol', 'limit': '$limit'})
          .then((r) => List<Trade>.from(r.map((m) => Trade.fromMap(m))));

  /// Aggregated trades from /api/v1/aggTrades
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#compressedaggregate-trades-list
  Future<List<AggregatedTrade>> aggregatedTrades(
    String symbol, {
    int fromId,
    DateTime startTime,
    DateTime endTime,
    int limit = 500,
  }) async {
    final params = {'symbol': '$symbol'};

    if (fromId != null) params['fromId'] = '$fromId';
    if (startTime != null)
      params['startTime'] = '${startTime?.millisecondsSinceEpoch}';
    if (endTime != null)
      params['endTime'] = '${endTime?.millisecondsSinceEpoch}';
    if (limit != null) params['limit'] = '$limit';

    final response = await _public('/v1/aggTrades', params);

    return List<AggregatedTrade>.from(
      response.map((t) => AggregatedTrade.fromMap(t)),
    );
  }

  /// Kline/Candlestick data from /v1/klines
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#klinecandlestick-data
  Future<List<Kline>> candlesticks(
    String symbol,
    Interval interval, {
    DateTime startTime,
    DateTime endTime,
    int limit = 500,
  }) async {
    final params = {
      'symbol': '$symbol',
      'interval': intervalMap[interval],
      'limit': '$limit',
    };

    if (startTime != null)
      params['startTime'] = startTime.millisecondsSinceEpoch.toString();
    if (endTime != null)
      params['endTime'] = endTime.millisecondsSinceEpoch.toString();

    final response = await _public('/v1/klines', params);

    return List<Kline>.from(
      response.map((c) => Kline.fromList(c)),
    );
  }

  /// Price ticker from /v3/ticker/price
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#symbol-price-ticker
  Future<TickerPrice> symbolPriceTicker(String symbol) async {
    assert(symbol != null);

    final response = await _public('/v1/ticker/price', {'symbol': symbol});

    return TickerPrice.fromMap(response);
  }

  /// All price tickers from /v3/ticker/price
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#symbol-price-ticker
  Future<List<TickerPrice>> allSymbolPriceTickers() async {
    final response = await _public('/v1/ticker/price');

    return List<TickerPrice>.from(response.map((s) => TickerPrice.fromMap(s)));
  }

  /// Symbol order book ticker from /v3/ticker/bookTicker
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#symbol-order-book-ticker
  Future<BookTicker> bookTicker(String symbol) async {
    final response = await _public('/v1/ticker/bookTicker', {'symbol': symbol});

    return BookTicker.fromMap(response);
  }

  /// All price tickers from /v3/ticker/price
  ///
  /// https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#symbol-order-book-ticker
  Future<List<BookTicker>> allBookTickers() async {
    final response = await _public('/v1/ticker/bookTicker');

    return List<BookTicker>.from(response.map((s) => BookTicker.fromMap(s)));
  }

  Future<FutureRestMarkPrice> markPrice(String symbol) async {
    final response = await _public('/v1/premiumIndex', {'symbol': symbol});

    return FutureRestMarkPrice.fromMap(response);
  }

  Future<List<FutureRestMarkPrice>> allMarkPrices() async {
    final response = await _public('/v1/premiumIndex');

    return List<FutureRestMarkPrice>.from(
        response.map((s) => FutureRestMarkPrice.fromMap(s)));
  }
}
