import Dispatch
import ExchangeRates

class CurrencySelectorPresenter {

  weak var presenterView: CurrencySelectorPresenterViewable? {
    didSet {
      fetchData()
      updateView()
    }
  }

  weak var delegate: CurrencySelectorPresenterDelegate?

  private let exchangeRatesManager: ExchangeRatesManagerProtocol
  private let selectedCurrency: Currency

  private var currencies = [Currency]() {
    didSet {
      currencies.sort { $0.localizedName < $1.localizedName }
    }
  }


  init(exchangeRatesManager: ExchangeRatesManagerProtocol, selectedCurrency: Currency) {
    self.exchangeRatesManager = exchangeRatesManager
    self.selectedCurrency = selectedCurrency
  }

  func didSelectCell(at row: Int) {
    let currency = currencies[row]
    delegate?.currencySelectorPresenter(self, didSelectCurrency: currency)
  }

  func didDismiss() {
    delegate?.currencySelectorPresenterDidDismiss(self)
  }

  private func fetchData() {
    currencies = Array(exchangeRatesManager.fetchCurrencies() ?? [])
  }

  private func updateView() {
    guard let index = currencies.firstIndex(where: { $0 == selectedCurrency }) else { return }
    presenterView?.showCurrencies(makeFormattedCurrencyList(), selectedIndex: index)
  }

  private func makeFormattedCurrencyList() -> [CurrencySelectorPresenterViewable.PresentedCurrency] {
    currencies.map {
      (name: $0.localizedName, code: $0.code)
    }
  }

}
