import XCTest
@testable import ExchangeRates

class ExchangeRatesTests: XCTestCase {

  private var rates: ExchangeRates!


  override func setUpWithError() throws {
    let date = Date(timeIntervalSince1970: 1234)

    // 1 AAA = 1.2 BBB
    // 1 AAA = 0.243 CCC
    rates = ExchangeRates(date: date, base: "AAA", quotes: [
      ExchangeRates.Quote(currency: "BBB", rate: 1.2),
      ExchangeRates.Quote(currency: "CCC", rate: 0.243)
    ])
  }

  func testRates() throws {
    XCTAssertEqual(rates.rate(for: "BBB"), 1.2)
    XCTAssertEqual(rates.rate(for: "CCC"), 0.243)
  }

  func testConvertRates() throws {
    let convRates = rates.convertedExchangeRates(to: "BBB")

    XCTAssertNotNil(convRates)
    XCTAssertNotNil(convRates!.rate(for: "AAA"))
    XCTAssertNotNil(convRates!.rate(for: "CCC"))

    // 1 AAA = 1.2 BBB
    // 1 BBB = 1/1.2 AAA
    // 1 BBB = 0.8333 AAA
    XCTAssertEqual(convRates!.rate(for: "AAA")!, 0.8333, accuracy: 0.0001)

    // 1 AAA = 0.243 CCC
    // 0.8333 AAA = 0.243 * 0.8333 CCC
    // 0.8333 AAA = 0.2025 CCC
    //
    // 1 BBB = 0.8333 AAA
    // 1 BBB = 0.8333 AAA = 0.2025 CCC
    // 1 BBB = 0.2025 CCC
     XCTAssertEqual(convRates!.rate(for: "CCC")!, 0.2025, accuracy: 0.0001)
  }

  func testFailConvertingRates() throws {
    let convRates = rates.convertedExchangeRates(to: "DDD")
    XCTAssertNil(convRates)
  }

}
