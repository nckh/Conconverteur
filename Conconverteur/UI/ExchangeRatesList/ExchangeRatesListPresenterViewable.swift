import Foundation

protocol ExchangeRatesListPresenterViewable: AnyObject {

  typealias PresentedExchangeRate = (currency: String, amount: String)

  func setCurrency(text: String?)
  func setAmount(text: String?)
  func updateExchangeRatesList(date: Date, list: [PresentedExchangeRate])
  func presentAlertError(message: String)
  func addDidActivateNotificationObserver(_ block: (() -> Void)?)

}
