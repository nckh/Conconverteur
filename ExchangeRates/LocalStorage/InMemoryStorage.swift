/// A temporary non-persisting storage.
class InMemoryStorage: LocalStorage {

  private var currencies: [Currency]?
  private var allExchangeRates = [Currency: ExchangeRates]()


  func fetchAnyBaseCurrency() -> Currency? {
    allExchangeRates.first?.key
  }

  func fetchCurrencies() -> Set<Currency>? {
    guard let currencies = currencies else { return nil }
    return Set(currencies)
  }

  func fetchExchangeRates(for currency: Currency) -> ExchangeRates? {
    allExchangeRates[currency]
  }

  func save(_ exchangeRates: ExchangeRates, completionHandler: (() -> Void)? = nil) {
    allExchangeRates[exchangeRates.base] = exchangeRates
    completionHandler?()
  }

}
