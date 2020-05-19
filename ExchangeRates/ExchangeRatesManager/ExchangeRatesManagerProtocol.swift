public protocol ExchangeRatesManagerProtocol {

  func fetchExchangeRates(for currency: Currency, completionHandler: FetchExchangeRatesCompletionHandler?)
  func fetchCurrencies() -> Set<Currency>?

}

public typealias FetchExchangeRatesCompletionHandler = (Result<ExchangeRates, Error>) -> Void
