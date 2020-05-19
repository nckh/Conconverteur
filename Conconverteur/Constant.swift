enum Constant {

  static let activityType = "com.nckh.Conconverteur.List"
  static let defaultBaseCurrency = "USD"
  static let maxDigits = 15

  enum CellReuseIdentifier {
    static let exchangeRate = "ExchangeRate"
    static let currency = "Currency"
  }

  enum StoryboardID {
    static let exchangeRatesList = "ExchangeRatesList"
    static let currencySelector = "CurrencySelector"
  }

  enum DefaultsKey {
    static let baseCurrency = "BaseCurrency"
  }

  enum InfoDictionaryKey {
    static let currencylayerAPIKey = "CurrencylayerAPIKey"
    static let useFakeData = "UseFakeData"
    static let useHTTPS = "UseHTTPS"
  }

}
