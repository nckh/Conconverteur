import UIKit

class ControllerFactory {

  private static let storyboard = UIStoryboard(name: "Main", bundle: nil)


  static func makeExchangeRatesListViewController(presenter: ExchangeRatesListPresenter) -> UIViewController {
    storyboard.instantiateViewController(identifier: Constant.StoryboardID.exchangeRatesList) {
      ExchangeRatesListViewController(coder: $0, presenter: presenter)
    }
  }

  static func makeCurrencySelectorViewController(presenter: CurrencySelectorPresenter) -> UIViewController {
    let vc = storyboard.instantiateViewController(identifier: Constant.StoryboardID.currencySelector) {
      CurrencySelectorViewController(coder: $0, presenter: presenter)
    }
    return UINavigationController(rootViewController: vc)
  }

  static func makeAlertViewController(message: String) -> UIAlertController {
    let alert = UIAlertController(
      title: NSLocalizedString("Error", comment: "Error alert title"),
      message: message,
      preferredStyle: .alert
    )

    let okAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Error alert dismiss button"), style: .default)
    alert.addAction(okAction)
    return alert
  }

}
