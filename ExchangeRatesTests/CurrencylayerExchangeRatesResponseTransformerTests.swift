import XCTest
@testable import ExchangeRates

class CurrencylayerExchangeRatesResponseTransformerTests: XCTestCase {

  private var transformer: CurrencylayerExchangeRatesResponseTransformer!


  override func setUpWithError() throws {
    transformer = CurrencylayerExchangeRatesResponseTransformer()
  }

  func testTransform() throws {
    let date = Date(timeIntervalSince1970: 1234)
    let response = CurrencylayerExchangeRatesResponse(date: date, base: "AAA", quotes: [
      "AAABBB": 1.2,
      "AAACCC": 0.243
    ])

    let exchangeRates = transformer.transform(response)

    XCTAssertEqual(exchangeRates.date, date)
    XCTAssertEqual(exchangeRates.quotes.count, 2)
    XCTAssertTrue(exchangeRates.quotes.contains(ExchangeRates.Quote(currency: "BBB", rate: 1.2)))
    XCTAssertTrue(exchangeRates.quotes.contains(ExchangeRates.Quote(currency: "CCC", rate: 0.243)))
  }

}
