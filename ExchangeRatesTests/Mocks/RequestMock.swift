import Foundation
@testable import ExchangeRates

class RequestMock: RequestProtocol {

  private let result: Result<Data, Error>


  init(result: Result<Data, Error>) {
    self.result = result
  }

  func load(completionHandler: RequestProtocol.CompletionHandler?) {
    completionHandler?(result)
  }

}
