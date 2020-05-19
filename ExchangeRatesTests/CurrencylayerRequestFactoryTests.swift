import XCTest
@testable import ExchangeRates

class CurrencylayerRequestFactoryTests: XCTestCase {

  private var factory: CurrencylayerRequestFactory!
  private var urlSessionMock: URLSessionMock!


  override func setUpWithError() throws {
    urlSessionMock = URLSessionMock()
    factory = CurrencylayerRequestFactory(apiKey: "abcd1234", useHTTPS: false, urlSession: urlSessionMock)
  }

  func testExchangeRatesRequest() throws {
    let request = factory.makeExchangeRatesRequest(for: "AAA")
    request.load(completionHandler: nil)

    XCTAssertEqual(urlSessionMock.url?.absoluteString, "http://api.currencylayer.com/live?access_key=abcd1234&source=AAA")
  }

}
