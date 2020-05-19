import ExchangeRates

class CurrencySelectorPresenterViewMock {

  var callsToShowCurrencies = [(currencies: [PresentedCurrency], selectedIndex: Int)]()
  var showCurrenciesCompletionBlock: (() -> Void)?

}


extension CurrencySelectorPresenterViewMock: CurrencySelectorPresenterViewable {

  func showCurrencies(_ currencies: [PresentedCurrency], selectedIndex: Int) {
    callsToShowCurrencies.append((currencies, selectedIndex))
    showCurrenciesCompletionBlock?()
  }

}
