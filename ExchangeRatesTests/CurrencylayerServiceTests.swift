import XCTest
@testable import ExchangeRates

class CurrencylayerServiceTests: XCTestCase {

  private var service: CurrencylayerService!
  private var urlSessionMock: URLSessionMock!
  private var task: URLSessionDataTaskMock!


  override func setUpWithError() throws {
    urlSessionMock = URLSessionMock()
    task = URLSessionDataTaskMock()
    service = CurrencylayerService(apiKey: "", useHTTPS: false, urlSession: urlSessionMock)
  }

  func testExchangeRatesOperation() throws {
    let jsonPayload = """
    {
      "timestamp":1234,
      "source":"AAA",
      "quotes":{
        "AAABBB":1.2,
        "AAACCC":0.243
      },
    }
    """
    let data = Data(jsonPayload.utf8)
    task.resultData = data
    urlSessionMock.task = task

    let operation = service.makeFetchExchangeRatesOperation(currency: "AAA")
    var result: Result<ExchangeRates, Error>?
    let expectation = XCTestExpectation()
    operation.queryCompletionBlock = { res in
      result = res
      expectation.fulfill()
    }

    operation.start()

    wait(for: [expectation], timeout: 1)
    guard case let .success(exchangeRates) = result else {
      XCTFail()
      return
    }

    XCTAssertEqual(exchangeRates.date, Date(timeIntervalSince1970: 1234))
    XCTAssertEqual(exchangeRates.base, "AAA")
    XCTAssertEqual(exchangeRates.quotes.count, 2)
    XCTAssertTrue(exchangeRates.quotes.contains(ExchangeRates.Quote(currency: "BBB", rate: 1.2)))
    XCTAssertTrue(exchangeRates.quotes.contains(ExchangeRates.Quote(currency: "CCC", rate: 0.243)))
  }

}
