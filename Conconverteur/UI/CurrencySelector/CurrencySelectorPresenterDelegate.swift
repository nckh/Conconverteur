import ExchangeRates

protocol CurrencySelectorPresenterDelegate: AnyObject {

  func currencySelectorPresenter(_ currencySelectorPresenter: CurrencySelectorPresenter, didSelectCurrency currency: Currency)
  func currencySelectorPresenterDidDismiss(_ currencySelectorPresenter: CurrencySelectorPresenter)

}
