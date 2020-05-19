@testable import ExchangeRates

class FailedQueryOperationFake<T>: QueryOperation<T> {

  private let error: Error


  init(_ error: Error) {
    self.error = error
  }

  override func main() {
    queryCompletionBlock?(.failure(error))
    finish()
  }

}
