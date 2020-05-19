@testable import ExchangeRates

class SuccessfulQueryOperationFake<T>: QueryOperation<T> {

  private let result: T


  init(_ result: T) {
    self.result = result
  }

  override func main() {
    queryCompletionBlock?(.success(result))
    finish()
  }

}
