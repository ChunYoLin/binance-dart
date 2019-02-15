import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../data/rest_classes.dart';
import '../data/enums.dart';

const BASE = 'https://api.binance.com';

class BinanceRest {
  Future<dynamic> _public(String path, [Map<String, String> params]) async {
    final uri = Uri.https('api.binance.com', '/api/$path', params);
    final response = await http.get(uri);

    return convert.jsonDecode(response.body);
  }

  /// Return true if the server is available with /v1/ping
  Future<bool> ping() => _public('/v1/ping').then((r) => true);

  /// Return the current server time from /v1/time
  Future<DateTime> time() => _public('/v1/time')
      .then((r) => DateTime.fromMillisecondsSinceEpoch(r['serverTime']));

  /// Returns general info about the exchange from /v1/exchangeInfo
  Future<ExchangeInfo> exchangeInfo() =>
      _public('/v1/exchangeInfo').then((r) => ExchangeInfo.fromMap(r));

  /// Order book depth from /v1/depth
  Future<BookDepth> depth(String symbol, [int limit = 100]) =>
      _public('/v1/depth', {'symbol': '$symbol', 'limit': '$limit'})
          .then((r) => BookDepth.fromMap(r));

  /// Recent trades from /v1/trades
  Future<List<Trade>> recentTrades(String symbol, [int limit = 500]) =>
      _public('/v1/trades', {'symbol': '$symbol', 'limit': '$limit'})
          .then((r) => List<Trade>.from(r.map((m) => Trade.fromMap(m))));

  /// Historical trades from /v1/aggTrades
  /// Authenticated endpoint

  /// Aggregated trades
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

  /// Current average price from /v3/avgPrice
  Future<AveragedPrice> averagePrice(String symbol) =>
      _public('/v3/avgPrice', {'symbol': symbol})
          .then((r) => AveragedPrice.fromMap(r));

  /// 24 hour ticker price change statistics
  Future<Stats> dailyStats(String symbol) async {
    assert(symbol != null);
    final response = await _public('/v1/ticker/24hr', {'symbol': symbol});

    return Stats.fromMap(response);
  }

  /// WARNING: this is VERY expensive and may cause rate limiting
  ///
  /// 24 hour ticker price change statistics for all coins
  Future<List<Stats>> allDailyStats() async {
    final response = await _public('/v1/ticker/24hr');

    return List<Stats>.from(response.map((s) => Stats.fromMap(s)));
  }

  /// Price ticker from /v3/ticker/price
  Future<TickerPrice> symbolPriceTicker(String symbol) async {
    assert(symbol != null);

    final response = await _public('/v3/ticker/price', {'symbol': symbol});

    return TickerPrice.fromMap(response);
  }

  /// All price tickers from /v3/ticker/price
  Future<List<TickerPrice>> allSymbolPriceTickers() async {
    final response = await _public('/v3/ticker/price');

    return List<TickerPrice>.from(response.map((s) => TickerPrice.fromMap(s)));
  }

  /// Symbol order book ticker from /v3/ticker/bookTicker
  Future<BookTicker> bookTicker(String symbol) async {
    final response = await _public('/v3/ticker/bookTicker', {'symbol': symbol});

    return BookTicker.fromMap(response);
  }

  /// All price tickers from /v3/ticker/price
  Future<List<BookTicker>> allBookTickers() async {
    final response = await _public('/v3/ticker/bookTicker');

    return List<BookTicker>.from(response.map((s) => BookTicker.fromMap(s)));
  }
}