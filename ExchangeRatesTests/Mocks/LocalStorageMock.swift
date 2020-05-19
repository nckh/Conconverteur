@testable import ExchangeRates

class LocalStorageMock {

  var storedCurrencies: [Currency]?
  var storedExchangeRates: [Currency: ExchangeRates]?
  var savedCurrencies = [Currency]()
  var savedExchangeRates = [Currency: ExchangeRates]()
  var currenciesWereSaved = false
  var exchangeRatesWereSaved = false

}


extension LocalStorageMock: LocalStorage {

  func fetchAnyBaseCurrency() -> Currency? {
    storedExchangeRates?.first?.key
  }

  func fetchCurrencies() -> Set<Currency>? {
    guard let currencies = storedCurrencies else { return nil }
    return Set(currencies)
  }

  func fetchExchangeRates(for currency: Currency) -> ExchangeRates? {
    storedExchangeRates?[currency]
  }

  func save(_ exchangeRates: ExchangeRates, completionHandler: (() -> Void)? = nil) {
    exchangeRatesWereSaved = true
    savedExchangeRates[exchangeRates.base] = exchangeRates
    completionHandler?()
  }

}
