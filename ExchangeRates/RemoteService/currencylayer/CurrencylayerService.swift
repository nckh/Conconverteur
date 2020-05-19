import Foundation

/// A service that downloads data from the currencylayer API.
class CurrencylayerService: CurrencylayerServiceProtocol {

  let operationQueue = OperationQueue()
  let requestFactory: RequestFactoryProtocol


  /// Creates a service that downloads data from the currencylayer API.
  /// - Parameters:
  ///   - apiKey: A currencylayer API key.
  ///   - useHTTPS: Whether to send HTTPS requests.
  ///   - urlSession: A URL session used to download data.
  init(apiKey: String, useHTTPS: Bool, urlSession: URLSessionProtocol = URLSession.shared) {
    requestFactory = CurrencylayerRequestFactory(apiKey: apiKey, useHTTPS: useHTTPS, urlSession: urlSession)
  }

}
