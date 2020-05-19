import Foundation

/// An operation used to retrieve exchange rates for a base currency from a local storage,
/// or from a remote service if the local ones have expired.
class CachedExchangeRatesOperation: QueryOperation<ExchangeRates> {

  private let currency: Currency
  private let localStorage: LocalStorage
  private let remoteService: RemoteService
  private let expirationTime: TimeInterval


  init(currency: Currency, localStorage: LocalStorage, remoteService: RemoteService, expirationTime: TimeInterval) {
    self.currency = currency
    self.localStorage = localStorage
    self.remoteService = remoteService
    self.expirationTime = expirationTime
  }

  override func main() {
    fetch { [weak self] result in
      self?.queryCompletionBlock?(result)
      self?.finish()
    }
  }

}


extension CachedExchangeRatesOperation: CachedDataFetcher {

  func loadFromStore() -> ExchangeRates? {
    localStorage.fetchExchangeRates(for: currency)
  }

  func hasExpired(data: ExchangeRates) -> Bool {
    data.date.distance(to: Date()) > expirationTime
  }

  func fetchRemotely(_ completionHandler: ((Result<T, Error>) -> Void)?) {
    let queue = Self.makeQueue()
    let operation = remoteService.makeFetchExchangeRatesOperation(currency: currency)
    operation.queryCompletionBlock = { completionHandler?($0) }
    queue.addOperation(operation)
  }

  func saveToStore(data: ExchangeRates) {
    localStorage.save(data, completionHandler: nil)
  }


  private static func makeQueue() -> OperationQueue {
    let queue = OperationQueue()
    queue.qualityOfService = .userInitiated
    return queue
  }

}
