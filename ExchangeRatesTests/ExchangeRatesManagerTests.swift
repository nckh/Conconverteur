import XCTest
@testable import ExchangeRates

class ExchangeRatesManagerTests: XCTestCase {

  private var manager: ExchangeRatesManager!
  private var localStorage: LocalStorageMock!
  private var remoteService: RemoteServiceMock!


  override func setUpWithError() throws {
    localStorage = LocalStorageMock()
    remoteService = RemoteServiceMock()
    let configuration = ExchangeRatesManagerConfiguration(
      localStorageLocation: .custom(localStorage),
      remoteServiceProvider: .custom(remoteService)
    )
    configuration.ratesExpirationTime = 30 * 60
    manager = ExchangeRatesManager(configuration: configuration)
  }

  func testFetchExchangeRates() throws {
    let expectedExchangeRates = Self.makeExchangeRates()
    remoteService.exchangeRatesOperation = SuccessfulQueryOperationFake(expectedExchangeRates)
    let expectation = XCTestExpectation()
    var result: Result<ExchangeRates, Error>?

    manager.fetchExchangeRates(for: "USD") { res in
      result = res
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)

    guard case let .success(exchangeRates) = result else {
      XCTFail()
      return
    }

    XCTAssertEqual(exchangeRates, expectedExchangeRates)
  }

  func testConvertExchangeRatesIfFetchFailed() throws {
    let fakeExchangeRates = Self.makeExchangeRates()

    localStorage.storedExchangeRates = ["USD": fakeExchangeRates]
    remoteService.exchangeRatesOperation = FailedQueryOperationFake(ErrorMock.whatever)
    let expectation = XCTestExpectation()
    var result: Result<ExchangeRates, Error>?

    manager.fetchExchangeRates(for: "BBB") { res in
      result = res
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)

    guard case let .success(exchangeRates) = result else {
      XCTFail()
      return
    }

    XCTAssertEqual(exchangeRates.base, "BBB")
  }

  func testSaveExchangeRatesInStorage() throws {
    let exchangeRates = Self.makeExchangeRates()
    remoteService.exchangeRatesOperation = SuccessfulQueryOperationFake(exchangeRates)
    let expectation = XCTestExpectation()

    manager.fetchExchangeRates(for: "USD") { _ in expectation.fulfill() }

    wait(for: [expectation], timeout: 1)

    XCTAssertEqual(localStorage.savedExchangeRates["USD"], exchangeRates)
  }

  func testFetchExchangeRatesIfTimeLimitExpired() throws {
    // 31 minutes ago
    let date = Date() - 31 * 60
    let exchangeRates = Self.makeExchangeRates(date: date)
    localStorage.storedExchangeRates = ["USD": exchangeRates]
    remoteService.exchangeRatesOperation = SuccessfulQueryOperationFake(Self.makeExchangeRates())
    let expectation = XCTestExpectation()

    manager.fetchExchangeRates(for: "USD") { _ in expectation.fulfill() }

    wait(for: [expectation], timeout: 1)

    XCTAssertTrue(remoteService.fetchExchangeRatesOperationWasCreated)
  }

  func testDontFetchExchangeRatesIfUnderTimeLimit() throws {
    // 29 minutes ago
    let date = Date() - 29 * 60
    let exchangeRates = Self.makeExchangeRates(date: date)
    localStorage.storedExchangeRates = ["USD": exchangeRates]
    remoteService.exchangeRatesOperation = SuccessfulQueryOperationFake(Self.makeExchangeRates())
    let expectation = XCTestExpectation()

    manager.fetchExchangeRates(for: "USD") { _ in expectation.fulfill() }

    wait(for: [expectation], timeout: 1)

    XCTAssertFalse(remoteService.fetchExchangeRatesOperationWasCreated)
  }

  func testDontResaveExchangeRatesLoadedFromStorage() throws {
    localStorage.storedCurrencies = Self.makeCurrencies()
    localStorage.storedExchangeRates = ["USD": Self.makeExchangeRates()]
    let expectation = XCTestExpectation()

    manager.fetchExchangeRates(for: "USD") { _ in expectation.fulfill() }

    wait(for: [expectation], timeout: 1)

    XCTAssertFalse(localStorage.exchangeRatesWereSaved)
  }


  // MARK: -

  private static func makeCurrencies() -> [Currency] {
    [
      Currency(code: "USD"),
      Currency(code: "BBB"),
      Currency(code: "CCC")
    ]
  }

  private static func makeExchangeRates(date: Date = .init()) -> ExchangeRates {
    let date = date
    return ExchangeRates(date: date, base: "USD", quotes: [
      ExchangeRates.Quote(currency: "BBB", rate: 1.4),
      ExchangeRates.Quote(currency: "CCC", rate: 0.124)
    ])
  }

}
