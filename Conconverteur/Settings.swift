import Foundation
import ExchangeRates

class Settings {

  var apiKey: String {
    (Bundle.main.object(forInfoDictionaryKey: InfoDictionaryKey.currencylayerAPIKey) as? String) ?? ""
  }

  var useFakeData: Bool {
    (Bundle.main.object(forInfoDictionaryKey: InfoDictionaryKey.useFakeData) as? Bool) ?? false
  }

  var useHTTPS: Bool {
    (Bundle.main.object(forInfoDictionaryKey: InfoDictionaryKey.useHTTPS) as? Bool) ?? true
  }

  var baseCurrency: Currency {
    get {
      let baseCurrencyCode = defaults.string(forKey: DefaultsKey.baseCurrency) ?? Constant.defaultBaseCurrency
      return Currency(code: baseCurrencyCode)
    }
    set {
      defaults.set(newValue.code, forKey: DefaultsKey.baseCurrency)
    }
  }

  private let defaults = UserDefaults.standard


  private init() {}


  static let shared = Settings()

}


private let DefaultsKey = Constant.DefaultsKey.self
private let InfoDictionaryKey = Constant.InfoDictionaryKey.self
