import ExchangeRates

class ExchangeRatesManagerMock: ExchangeRatesManagerProtocol {

  var exchangeRatesResult: Result<ExchangeRates, Error>!
  var currencies = Set<Currency>()
  var callsToFetchExchangeRates = [Currency]()
  var callsToFetchCurrencies = 0


  func fetchExchangeRates(for currency: Currency, completionHandler: FetchExchangeRatesCompletionHandler?) {
    callsToFetchExchangeRates.append(currency)
    completionHandler?(self.exchangeRatesResult!)
  }

  func fetchCurrencies() -> Set<Currency>? {
    callsToFetchCurrencies += 1
    return currencies
  }

}
