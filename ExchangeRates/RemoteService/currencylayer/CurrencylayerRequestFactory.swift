import Foundation

/// A factory that creates requests to download from the currencylayer API.
class CurrencylayerRequestFactory: RequestFactoryProtocol {

  private let apiKey: String
  private let useHTTPS: Bool
  private let urlSession: URLSessionProtocol


  init(apiKey: String, useHTTPS: Bool, urlSession: URLSessionProtocol = URLSession.shared) {
    self.apiKey = apiKey
    self.useHTTPS = useHTTPS
    self.urlSession = urlSession
  }

  func makeExchangeRatesRequest(for currency: Currency) -> RequestProtocol {
    let queryItems = [URLQueryItem(name: "source", value: currency.code)]
    return CurrencylayerRequest(path: "/live", queryItems: queryItems, apiKey: apiKey, useHTTPS: useHTTPS, urlSession: urlSession)
  }

}
