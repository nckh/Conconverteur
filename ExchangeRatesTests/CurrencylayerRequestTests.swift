import XCTest
@testable import ExchangeRates

class CurrencylayerRequestTests: XCTestCase {

  private var request: CurrencylayerRequest!
  private var urlSessionMock: URLSessionMock!
  private var task: URLSessionDataTaskMock!


  override func setUpWithError() throws {
    urlSessionMock = URLSessionMock()
    task = URLSessionDataTaskMock()
  }

  func testURL() throws {
    let queryItems = [URLQueryItem(name: "item", value: "glagla")]
    let apiKey = "abcd1234"
    let request = CurrencylayerRequest(path: "/gigou", queryItems: queryItems, apiKey: apiKey, useHTTPS: true, urlSession: urlSessionMock)

    request.load()

    XCTAssertEqual(urlSessionMock.url?.absoluteString, "https://api.currencylayer.com/gigou?access_key=abcd1234&item=glagla")
  }

  func testDataTaskResumes() throws {
    urlSessionMock.task = task
    let request = CurrencylayerRequest(path: "", queryItems: [], apiKey: "", useHTTPS: true, urlSession: urlSessionMock)

    request.load()

    XCTAssertTrue(task.resumeWasCalled)
  }

  func testDataTaskDoesNotResume() throws {
    urlSessionMock.task = task

    _ = CurrencylayerRequest(path: "", queryItems: [], apiKey: "", useHTTPS: true, urlSession: urlSessionMock)

    XCTAssertFalse(task.resumeWasCalled)
  }

  func testData() throws {
    task.resultData = Data("Glouglou".utf8)
    urlSessionMock.task = task
    let request = CurrencylayerRequest(path: "", queryItems: [], apiKey: "", useHTTPS: true, urlSession: urlSessionMock)
    var result: Result<Data, Error>?
    let expectation = XCTestExpectation()

    request.load { res in
      result = res
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)

    if case let .success(data) = result {
      let string = String(data: data, encoding: .utf8)
      XCTAssertEqual(string, "Glouglou")
    } else {
      XCTFail()
    }
  }

  func testError() throws {
    task.resultError = ErrorMock.whatever
    urlSessionMock.task = task
    let request = CurrencylayerRequest(path: "", queryItems: [], apiKey: "", useHTTPS: true, urlSession: urlSessionMock)
    var result: Result<Data, Error>?
    let expectation = XCTestExpectation()

    request.load { res in
      result = res
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)

    guard case let .failure(error) = result else {
      XCTFail()
      return
    }

    guard case CurrencylayerRequestError.loadingError = error else {
      XCTFail()
      return
    }
  }

}
