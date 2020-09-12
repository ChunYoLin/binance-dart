abstract class _WebsocketBase {
  String get eventType;
  DateTime get eventTime;
  String get symbol;
}

/// Represents data provided by <symbol>@markPrice and !markPrice@arr
///
///

class MarkPrice implements _WebsocketBase {
  final String eventType;
  final DateTime eventTime;
  final String symbol;

  final String markPrice;
  final String indexPrice;
  final String fundingRate;
  final DateTime nextFundingTime;

  MarkPrice.fromMap(Map m)
      : this.eventType = m["e"],
        this.eventTime = DateTime.fromMillisecondsSinceEpoch(m["E"]),
        this.symbol = m["s"],
        this.markPrice = m["p"],
        this.indexPrice = m["i"],
        this.fundingRate = m["r"],
        this.nextFundingTime = DateTime.fromMillisecondsSinceEpoch(m["T"]);

  MarkPrice.clone(MarkPrice markPrice)
      : this.eventType = markPrice.eventType,
        this.eventTime = markPrice.eventTime,
        this.symbol = markPrice.symbol,
        this.markPrice = markPrice.markPrice,
        this.indexPrice = markPrice.indexPrice,
        this.fundingRate = markPrice.fundingRate,
        this.nextFundingTime = markPrice.nextFundingTime;
}

class FutureBookTicker {
  final DateTime eventTime;
  final DateTime transactionTime;
  final String symbol;
  final int updateID;
  final double bidPrice;
  final double bidQty;
  final double askPrice;
  final double askQty;

  FutureBookTicker.fromMap(Map m)
      : this.updateID = m["u"],
        this.eventTime = DateTime.fromMillisecondsSinceEpoch(m["E"]),
        this.transactionTime = DateTime.fromMillisecondsSinceEpoch(m["T"]),
        this.symbol = m["s"],
        this.bidPrice = double.parse(m["b"]),
        this.bidQty = double.parse(m["B"]),
        this.askPrice = double.parse(m["a"]),
        this.askQty = double.parse(m["A"]);

  FutureBookTicker.clone(FutureBookTicker futureBookTicker)
      : this.symbol = futureBookTicker.symbol,
        this.eventTime = futureBookTicker.eventTime,
        this.transactionTime = futureBookTicker.transactionTime,
        this.updateID = futureBookTicker.updateID,
        this.bidPrice = futureBookTicker.bidPrice,
        this.bidQty = futureBookTicker.bidQty,
        this.askPrice = futureBookTicker.askPrice,
        this.askQty = futureBookTicker.askQty;
}
