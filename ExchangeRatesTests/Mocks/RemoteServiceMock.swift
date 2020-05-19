@testable import ExchangeRates

class RemoteServiceMock {

  let operationQueue = OperationQueue()
  var exchangeRatesOperation: QueryOperation<ExchangeRates>!
  var fetchExchangeRatesOperationWasCreated = false

}


extension RemoteServiceMock: RemoteService {

  func makeFetchExchangeRatesOperation(currency: Currency) -> QueryOperation<ExchangeRates> {
    fetchExchangeRatesOperationWasCreated = true
    return exchangeRatesOperation
  }

}
