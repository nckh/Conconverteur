import Foundation
import os.log

/// A request downloading data from the currencylayer API.
class CurrencylayerRequest: RequestProtocol {

  private let path: String
  private let queryItems: [URLQueryItem]
  private let apiKey: String
  private let useHTTPS: Bool
  private let urlSession: URLSessionProtocol


  init(path: String, queryItems: [URLQueryItem], apiKey: String, useHTTPS: Bool, urlSession: URLSessionProtocol) {
    self.path = path
    self.queryItems = queryItems
    self.apiKey = apiKey
    self.useHTTPS = useHTTPS
    self.urlSession = urlSession
  }

  func load(completionHandler: RequestProtocol.CompletionHandler? = nil) {
    guard let url = makeURL() else {
      fatalError("Could not assemble endpoint URL")
    }

    os_log(.info, "Start downloading data from %@", url.absoluteString)

    let task = urlSession.dataTask(with: url) { data, _, error in
      guard error == nil else {
        completionHandler?(.failure(CurrencylayerRequestError.loadingError(error!.localizedDescription)))
        return
      }

      guard let data = data else {
        completionHandler?(.failure(CurrencylayerRequestError.unknown))
        return
      }

      completionHandler?(.success(data))
    }

    task.resume()
  }

  private func makeURL() -> URL? {
    var urlComponents = URLComponents()

    urlComponents.scheme = useHTTPS ? "https" : "http"
    urlComponents.host = Self.host
    urlComponents.path = path

    urlComponents.queryItems = [
      URLQueryItem(name: "access_key", value: apiKey)
    ]

    urlComponents.queryItems?.append(contentsOf: queryItems)

    return urlComponents.url
  }


  private static let host = "api.currencylayer.com"

}
