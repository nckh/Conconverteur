import Foundation

/// The format of the `/live` payload of the currencylayer API.
struct CurrencylayerExchangeRatesResponse: Decodable {

  typealias CurrencyPair = String

  let date: Date
  let base: Currency
  let quotes: [CurrencyPair: Double]


  enum CodingKeys: String, CodingKey {
    case quotes
    case base = "source"
    case date = "timestamp"
  }

}
