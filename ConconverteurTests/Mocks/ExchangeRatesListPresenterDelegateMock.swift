class ExchangeRatesListPresenterDelegateMock: ExchangeRatesListPresenterDelegate {

  var callsToDidTapCurrency = 0


  func exchangeRatesListPresenterDidTapCurrency(_ exchangeRatesListPresenter: ExchangeRatesListPresenter) {
    callsToDidTapCurrency += 1
  }

}
