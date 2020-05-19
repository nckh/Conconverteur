import Foundation
import ExchangeRates

class ExchangeRatesListPresenter {

  var amount: Double

  var baseCurrency: Currency {
    didSet {
      fetchExchangeRates()
    }
  }

  weak var presenterView: ExchangeRatesListPresenterViewable? {
    didSet {
      updateView()
      setupAutoRefresh()
    }
  }

  weak var delegate: ExchangeRatesListPresenterDelegate?

  private let exchangeRatesManager: ExchangeRatesManagerProtocol
  private var exchangeRates: ExchangeRates?


  init(exchangeRatesManager: ExchangeRatesManagerProtocol, baseCurrency: Currency, amount: Double) {
    self.exchangeRatesManager = exchangeRatesManager
    self.baseCurrency = baseCurrency
    self.amount = amount
  }

  func didEditAmount(_ amount: String?) {
    self.amount = Double(amount ?? "") ?? 0
    updateList()
  }

  func didTapCurrency() {
    delegate?.exchangeRatesListPresenterDidTapCurrency(self)
  }

  private func updateView() {
    presenterView?.setCurrency(text: baseCurrency.locale?.currencySymbol ?? baseCurrency.code)
    presenterView?.setAmount(text: Self.formattedAmount(amount))

    updateList()
  }

  private func updateList() {
    guard
      let exchangeRates = exchangeRates,
      let list = makeFormattedExchangeRatesList() else {
        return
    }

    presenterView?.updateExchangeRatesList(date: exchangeRates.date, list: list)
  }

  private func setupAutoRefresh() {
    presenterView?.addDidActivateNotificationObserver { [weak self] in
      self?.fetchExchangeRates()
    }
  }

  @objc private func fetchExchangeRates() {
    exchangeRatesManager.fetchExchangeRates(for: baseCurrency) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case let .failure(error):
          self?.presenterView?.presentAlertError(message: error.localizedDescription)

        case let .success(exchangeRates):
          self?.exchangeRates = exchangeRates
          self?.updateView()
        }
      }
    }
  }

  private func makeFormattedExchangeRatesList() -> [ExchangeRatesListPresenterViewable.PresentedExchangeRate]? {
    exchangeRates?.quotes
      .sorted { $0.currency.localizedName < $1.currency.localizedName }
      .filter { $0.currency != exchangeRates?.base }
      .compactMap { quote in
        let totalAmount = quote.rate * amount
        let formattedAmount = quote.currency.localizedAmountWithCurrencySymbol(totalAmount)
        return (currency: quote.currency.localizedName.firstLetterCapitalized, amount: formattedAmount)
    }
  }


  private static var amountFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 16
    return formatter
  }()


  private static func formattedAmount(_ amount: Double) -> String {
    amountFormatter.string(from: amount as NSNumber) ?? ""
  }

}
