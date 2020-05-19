import Foundation
import os.log

/// A service to fetch exchange rates online, and store them locally.
public class ExchangeRatesManager: ExchangeRatesManagerProtocol {

  private let configuration: ExchangeRatesManagerConfiguration
  private let localStorage: LocalStorage
  private let remoteService: RemoteService
  private var ratesExpirationTime: TimeInterval { configuration.ratesExpirationTime }


  /// A service to fetch exchange rates online, and store them locally.
  /// - Parameter configuration: The configuration for the manager.
  public init(configuration: ExchangeRatesManagerConfiguration) {
    self.configuration = configuration
    localStorage = configuration.localStorage
    remoteService = configuration.remoteService
  }

  /// Fetches the exchange rates for a currency, and returns the result asynchronously.
  /// - Parameters:
  ///   - currency: The currency.
  ///   - completionHandler: A completion block executed with the result of the request.
  public func fetchExchangeRates(for currency: Currency, completionHandler: FetchExchangeRatesCompletionHandler? = nil) {
    let queue = Self.makeQueue()
    var result: Result<ExchangeRates, Error>?

    // Fetch exchange rates from local storage or remote service
    let fetchOperation = CachedExchangeRatesOperation(
      currency: currency,
      localStorage: localStorage,
      remoteService: remoteService,
      expirationTime: ratesExpirationTime
    )

    fetchOperation.queryCompletionBlock = { result = $0 }
    queue.addOperation(fetchOperation)

    // Send exchange rates to completion handler
    let completionOperation = BlockOperation { [weak self] in
      switch result {
      case let .success(exchangeRates):
        completionHandler?(.success(exchangeRates))

      case let .failure(exchangeRatesError):
        os_log(.error, "Could not fetch exchange rates: %@", exchangeRatesError.localizedDescription)

        if let convertedRates = self?.convertedExchangeRates(to: currency) {
          os_log(.info, "Converting from locally stored exchange rates to %@", currency.code)
          completionHandler?(.success(convertedRates))

        } else {
          completionHandler?(.failure(exchangeRatesError))
        }

      default: break
      }
    }

    completionOperation.addDependency(fetchOperation)
    queue.addOperation(completionOperation)
  }

  /// Returns all currencies from local storage.
  /// - Returns: A list of currencies.
  public func fetchCurrencies() -> Set<Currency>? {
    localStorage.fetchCurrencies()
  }

  /// Attempts to find and convert a set of locally stored conversion rates to another base
  /// currency.
  /// - Parameter currency: The new base currency to convert to.
  /// - Returns: A new set of conversion rates.
  private func convertedExchangeRates(to currency: Currency) -> ExchangeRates? {
    guard
      let base = localStorage.fetchAnyBaseCurrency(),
      let exchangeRates = localStorage.fetchExchangeRates(for: base) else {
        return nil
    }
    return exchangeRates.convertedExchangeRates(to: currency)
  }


  private static func makeQueue() -> OperationQueue {
    let queue = OperationQueue()
    queue.qualityOfService = .userInitiated
    return queue
  }

}
