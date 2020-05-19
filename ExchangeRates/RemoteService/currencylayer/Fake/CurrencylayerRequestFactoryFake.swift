/// A factory that creates requests to download data from static JSON files located in the bundle.
class CurrencylayerRequestFactoryFake: RequestFactoryProtocol {

  func makeExchangeRatesRequest(for currency: Currency) -> RequestProtocol {
    let fileName = "live-\(currency.code.lowercased())"
    return CurrencylayerRequestFake(fileName: fileName)
  }

}
