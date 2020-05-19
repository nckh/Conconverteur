import Foundation

/// A value that represents a list of conversion rates for a base currency (or source currency)
/// at a given time.
public struct ExchangeRates: Equatable {

  public let date: Date
  public let base: Currency
  public let quotes: [Quote]

  private let quoteDict: [Currency: Double]


  public init(date: Date, base: Currency, quotes: [Quote]) {
    self.date = date
    self.base = base
    self.quotes = quotes

    var quoteDict = [Currency: Double]()
    quotes.forEach { quoteDict[$0.currency] = $0.rate }
    self.quoteDict = quoteDict
  }

  /// Returns the conversion rate for a given quote currency.
  /// - Parameter currency: A quote currency.
  /// - Returns: The conversion rate.
  func rate(for currency: Currency) -> Double? {
    if currency == base { return 1 }
    return quoteDict[currency]
  }

  /// Returns a new list of conversion rates, converted to another base currency.
  /// - Parameter base: The new base currency to convert to.
  /// - Returns: A new list of conversion rates.
  func convertedExchangeRates(to base: Currency) -> ExchangeRates? {
    let originalBase = self.base
    let newBase = base

    // Stop here if there's no rate available
    guard let newBaseRate = rate(for: newBase) else { return nil }

    var currencies: [Currency] = quotes.compactMap { quote in
      guard quote.currency != base else { return nil }
      return quote.currency
    }
    currencies.append(originalBase)

    let convertedQuotes: [Quote] = currencies.compactMap { quote in
      guard let baseRate = rate(for: quote) else { return nil }
      let rate = baseRate / newBaseRate
      return Quote(currency: quote, rate: rate)
    }

    return ExchangeRates(date: date, base: newBase, quotes: convertedQuotes)
  }


  // MARK: -

  /// A value that represents a quote currency and its price.
  public struct Quote: Equatable {
    public let currency: Currency
    public let rate: Double
  }

}
