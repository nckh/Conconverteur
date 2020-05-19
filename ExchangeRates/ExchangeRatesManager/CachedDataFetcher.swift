/// A type that provides data retrieval from a local storage, or from a remote service if the local data has expired.
protocol CachedDataFetcher: AnyObject {

  associatedtype T

  func loadFromStore() -> T?
  func hasExpired(data: T) -> Bool
  func fetchRemotely(_ completionHandler: ((Result<T, Error>) -> Void)?)
  func saveToStore(data: T)

}


extension CachedDataFetcher {

  func fetch(_ completionHandler: ((Result<T, Error>) -> Void)? = nil) {
    // Attempt to fetch fresh data stored locally
    if let data = loadFromStore(), !hasExpired(data: data) {
      // Data available in store and still fresh, return it
      completionHandler?(.success(data))
      return
    }

    // No fresh data in local storage, fetch latest data from remote service
    fetchRemotely { [weak self] result in
      if case let .success(data) = result {
        self?.saveToStore(data: data)
      }

      completionHandler?(result)
    }
  }

}
