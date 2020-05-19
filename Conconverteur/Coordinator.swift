import UIKit
import ExchangeRates

class Coordinator {

  private let window: UIWindow
  private var mainViewController: UIViewController!

  private lazy var exchangeRatesManager: ExchangeRatesManager = makeExchangeRatesManager()
  private var exchangeRatesListPresenter: ExchangeRatesListPresenter!
  private let settings: Settings
  private let userActivity: NSUserActivity?


  init(window: UIWindow, settings: Settings = .shared, userActivity: NSUserActivity? = nil) {
    self.window = window
    self.settings = settings
    self.userActivity = userActivity

    showRootViewController()
  }

  func makeUserActivity() -> NSUserActivity {
    let activity = NSUserActivity(activityType: Constant.activityType)
    activity.title = "Restoration activity"
    activity.addUserInfoEntries(from: ["amount": exchangeRatesListPresenter.amount])
    return activity
  }

  private func showRootViewController() {
    let baseCurrency = settings.baseCurrency
    let initialAmount = userActivity?.userInfo?["amount"] as? Double
    let amount: Double = initialAmount ?? 1

    let presenter = ExchangeRatesListPresenter(exchangeRatesManager: exchangeRatesManager, baseCurrency: baseCurrency, amount: amount)
    presenter.delegate = self
    exchangeRatesListPresenter = presenter

    let vc = ControllerFactory.makeExchangeRatesListViewController(presenter: presenter)
    mainViewController = vc

    window.rootViewController = mainViewController
    window.makeKeyAndVisible()
  }

  private func presentCurrencySelector() {
    let selectedCurrency = exchangeRatesListPresenter.baseCurrency
    let presenter = CurrencySelectorPresenter(exchangeRatesManager: exchangeRatesManager, selectedCurrency: selectedCurrency)
    presenter.delegate = self

    let vc = ControllerFactory.makeCurrencySelectorViewController(presenter: presenter)
    mainViewController.present(vc, animated: true)
  }

  private func makeExchangeRatesManager() -> ExchangeRatesManager {
    let configuration = ExchangeRatesManagerConfiguration(
      localStorageLocation: .coreData,
      remoteServiceProvider: makeRemoteServiceProvider()
    )

    return ExchangeRatesManager(configuration: configuration)
  }

  private func makeRemoteServiceProvider() -> ExchangeRatesManagerConfiguration.RemoteServiceProvider {
    if settings.useFakeData {
      return .currencylayerFake
    }

    return .currencylayer(
      apiKey: settings.apiKey,
      useHTTPS: settings.useHTTPS
    )
  }

}


// MARK: - ExchangeRatesListPresenterDelegate

extension Coordinator: ExchangeRatesListPresenterDelegate {

  func exchangeRatesListPresenterDidTapCurrency(_ exchangeRatesListPresenter: ExchangeRatesListPresenter) {
    presentCurrencySelector()
  }

}


// MARK: - CurrencySelectorPresenterDelegate

extension Coordinator: CurrencySelectorPresenterDelegate {

  func currencySelectorPresenter(_ currencySelectorPresenter: CurrencySelectorPresenter, didSelectCurrency currency: Currency) {
    Settings.shared.baseCurrency = currency
    exchangeRatesListPresenter.baseCurrency = currency
    mainViewController.dismiss(animated: true)
  }

  func currencySelectorPresenterDidDismiss(_ currencySelectorPresenter: CurrencySelectorPresenter) {
    mainViewController.dismiss(animated: true)
  }

}
