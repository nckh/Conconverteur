import ExchangeRates

protocol CurrencySelectorPresenterViewable: AnyObject {

  typealias PresentedCurrency = (name: String, code: String)

  func showCurrencies(_ currencies: [PresentedCurrency], selectedIndex: Int)

}
