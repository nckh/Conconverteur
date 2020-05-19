import Foundation
import ExchangeRates

class ExchangeRatesListPresenterViewMock: NSObject {

  var callsToSetCurrency = [String?]()
  var callsToSetAmount = [String?]()
  var callsToUpdateExchangeRatesList = [(date: Date, list: [PresentedExchangeRate])]()
  var callsToPresentAlertError = [String]()
  var activateObserverBlock: (() -> Void)?
  var updateExchangeRatesListCompletionBlock: (() -> Void)?
  var presentAlertErrorCompletionBlock: (() -> Void)?


  func setCurrency(text: String?) {
    callsToSetCurrency.append(text)
  }

  func setAmount(text: String?) {
    callsToSetAmount.append(text)
  }

  func updateExchangeRatesList(date: Date, list: [PresentedExchangeRate]) {
    callsToUpdateExchangeRatesList.append((date, list))
    updateExchangeRatesListCompletionBlock?()
  }

  func presentAlertError(message: String) {
    callsToPresentAlertError.append(message)
    presentAlertErrorCompletionBlock?()
  }

  func addDidActivateNotificationObserver(_ block: (() -> Void)?) {
    activateObserverBlock = block
  }

  func triggerActivateNotification() {
    activateObserverBlock?()
  }

}

extension ExchangeRatesListPresenterViewMock: ExchangeRatesListPresenterViewable {}
