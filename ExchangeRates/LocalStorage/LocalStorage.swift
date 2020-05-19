public protocol LocalStorage: AnyObject {

  func fetchAnyBaseCurrency() -> Currency?
  func fetchCurrencies() -> Set<Currency>?
  func fetchExchangeRates(for currency: Currency) -> ExchangeRates?
  func save(_ exchangeRates: ExchangeRates, completionHandler: (() -> Void)?)

}
