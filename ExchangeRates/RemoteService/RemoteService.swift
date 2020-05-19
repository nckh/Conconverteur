import Foundation

/// An abstraction for any object that can create operations fetching exchange rates from any kind of source.
public protocol RemoteService {

  var operationQueue: OperationQueue { get }

  func makeFetchExchangeRatesOperation(currency: Currency) -> QueryOperation<ExchangeRates>

}


extension RemoteService {

  /// A convenience method to fetch the exchange rates for a currency without creating a queue.
  /// - Parameters:
  ///   - currency: The currency.
  ///   - completionHandler: A completion block executed with the result of the request.
  func fetchExchangeRates(for currency: Currency, completionHandler: FetchExchangeRatesCompletionHandler?) {
    let operation = makeFetchExchangeRatesOperation(currency: currency)
    operation.queryCompletionBlock = completionHandler
    operationQueue.addOperation(operation)
  }

}
