import XCTest
@testable import ExchangeRates

class CurrencylayerOperationTests: XCTestCase {

  func testDataError() throws {
    let request = RequestMock(result: .failure(ErrorMock.whatever))
    let dataTransformer = IdenticalTransformer<String>()
    let operation = CurrencylayerOperation(request: request, dataTransformer: dataTransformer)
    var result: Result<String, Error>?
    let expectation = XCTestExpectation()
    operation.queryCompletionBlock = { res in
      result = res
      expectation.fulfill()
    }

    operation.start()

    wait(for: [expectation], timeout: 1)

    guard case let .failure(error) = result else {
      XCTFail()
      return
    }

    guard case ErrorMock.whatever = error else {
      XCTFail()
      return
    }
  }

  func testAPIError() throws {
    let jsonPayload = """
    {
      "success":false,
      "error":{
        "code":999,
        "info":"Glouglou"
      }
    }
    """
    let data = Data(jsonPayload.utf8)
    let request = RequestMock(result: .success(data))
    let dataTransformer = IdenticalTransformer<String>()
    let operation = CurrencylayerOperation(request: request, dataTransformer: dataTransformer)
    var result: Result<String, Error>?
    let expectation = XCTestExpectation()
    operation.queryCompletionBlock = { res in
      result = res
      expectation.fulfill()
    }

    operation.start()

    wait(for: [expectation], timeout: 1)

    guard case let .failure(error) = result else {
      XCTFail()
      return
    }

    guard case let CurrencylayerOperationError.apiError(currencylayerError) = error else {
      XCTFail()
      return
    }

    XCTAssertEqual(currencylayerError.code, 999)
    XCTAssertEqual(currencylayerError.info, "Glouglou")
  }

  func testCouldNotDecode() throws {
    let jsonPayload = """
    {"whatever":true}
    """
    let data = Data(jsonPayload.utf8)
    let request = RequestMock(result: .success(data))
    let dataTransformer = IdenticalTransformer<String>()
    let operation = CurrencylayerOperation(request: request, dataTransformer: dataTransformer)
    var result: Result<String, Error>?
    let expectation = XCTestExpectation()
    operation.queryCompletionBlock = { res in
      result = res
      expectation.fulfill()
    }

    operation.start()

    wait(for: [expectation], timeout: 1)

    guard case let .failure(error) = result else {
      XCTFail()
      return
    }

    guard case CurrencylayerOperationError.couldNotDecode = error else {
      XCTFail()
      return
    }
  }

  func testTransformResponse() throws {
    let jsonPayload = """
    {"whatever":true}
    """
    let data = Data(jsonPayload.utf8)
    let request = RequestMock(result: .success(data))
    let dataTransformer = WhateverTransformer()
    let operation = CurrencylayerOperation(request: request, dataTransformer: dataTransformer)
    var result: Result<TransformedWhatever, Error>?
    let expectation = XCTestExpectation()
    operation.queryCompletionBlock = { res in
      result = res
      expectation.fulfill()
    }

    operation.start()

    wait(for: [expectation], timeout: 1)

    guard case let .success(whatev) = result else {
      XCTFail()
      return
    }

    XCTAssertEqual(whatev.message, "YES")
  }

  func testFinishes() throws {
    let jsonPayload = """
    {"whatever":true}
    """
    let data = Data(jsonPayload.utf8)
    let request = RequestMock(result: .success(data))
    let dataTransformer = WhateverTransformer()
    let operation = CurrencylayerOperation(request: request, dataTransformer: dataTransformer)
    var result: Result<TransformedWhatever, Error>?
    operation.queryCompletionBlock = { result = $0 }
    let expectation = XCTestExpectation()
    let completionOperation = BlockOperation { expectation.fulfill() }

    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.addOperations([operation, completionOperation], waitUntilFinished: false)

    wait(for: [expectation], timeout: 1)

    guard case .success = result else {
      XCTFail()
      return
    }
  }

}


// MARK: -

private struct Whatever: Decodable {
  let whatever: Bool
}

private struct TransformedWhatever {
  let message: String
}

private struct IdenticalTransformer<T: Decodable>: DataTransformer {
  func transform(_ input: T) -> T { input }
}

private struct WhateverTransformer: DataTransformer {
  func transform(_ input: Whatever) -> TransformedWhatever {
    TransformedWhatever(message: input.whatever ? "YES" : "NO")
  }
}
