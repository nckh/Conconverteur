import ExchangeRates

class CurrencySelectorPresenterDelegateMock: CurrencySelectorPresenterDelegate {

  var callsToDidSelectCurrency = [Currency]()
  var callsToDidDismiss = 0


  func currencySelectorPresenter(_ currencySelectorPresenter: CurrencySelectorPresenter, didSelectCurrency currency: Currency) {
    callsToDidSelectCurrency.append(currency)
  }

  func currencySelectorPresenterDidDismiss(_ currencySelectorPresenter: CurrencySelectorPresenter) {
    callsToDidDismiss += 1
  }

}
