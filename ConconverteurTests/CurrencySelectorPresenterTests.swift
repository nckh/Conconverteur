import XCTest
import ExchangeRates

class CurrencySelectorPresenterTests: XCTestCase {

  private var presenter: CurrencySelectorPresenter!
  private var presenterViewMock: CurrencySelectorPresenterViewMock!
  private var managerMock: ExchangeRatesManagerMock!
  private var currencies: Set<Currency>!

  override func setUpWithError() throws {
    currencies = Self.makeCurrencies()
    managerMock = ExchangeRatesManagerMock()
    managerMock.currencies = currencies

    presenter = CurrencySelectorPresenter(exchangeRatesManager: managerMock, selectedCurrency: "JPY")
    presenterViewMock = CurrencySelectorPresenterViewMock()
  }

  func testFetchCurrenciesAtStart() throws {
    let expectation = XCTestExpectation()
    presenterViewMock.showCurrenciesCompletionBlock = { expectation.fulfill() }

    presenter.presenterView = presenterViewMock

    wait(for: [expectation], timeout: 1)

    XCTAssertEqual(managerMock.callsToFetchCurrencies, 1)
  }

  func testShowFetchedCurrencies() throws {
    let expectation = XCTestExpectation()
    presenterViewMock.showCurrenciesCompletionBlock = { expectation.fulfill() }

    presenter.presenterView = presenterViewMock

    wait(for: [expectation], timeout: 1)

    let call = presenterViewMock.callsToShowCurrencies[0]
    XCTAssertNotNil(call)
    XCTAssertEqual(call.currencies.count, 3)
    if call.currencies.count != 3 { return }
    XCTAssertEqual(call.currencies[0].name, "Euro")
    XCTAssertEqual(call.currencies[0].code, "EUR")
    XCTAssertEqual(call.currencies[1].name, "Japanese Yen")
    XCTAssertEqual(call.currencies[1].code, "JPY")
    XCTAssertEqual(call.currencies[2].name, "US Dollar")
    XCTAssertEqual(call.currencies[2].code, "USD")
    XCTAssertEqual(call.selectedIndex, 1)
  }

  func testCallDelegateAfterSelectingCurrency() throws {
    let delegateMock = CurrencySelectorPresenterDelegateMock()
    presenter.delegate = delegateMock
    let expectation = XCTestExpectation()
    presenterViewMock.showCurrenciesCompletionBlock = { expectation.fulfill() }
    presenter.presenterView = presenterViewMock

    wait(for: [expectation], timeout: 1)

    presenter.didSelectCell(at: 0)
    presenter.didSelectCell(at: 1)
    presenter.didSelectCell(at: 2)

    XCTAssertEqual(delegateMock.callsToDidSelectCurrency.count, 3)
  }

  func testCallDelegateAfterDismissingSelector() throws {
    let delegateMock = CurrencySelectorPresenterDelegateMock()
    presenter.delegate = delegateMock
    let expectation = XCTestExpectation()
    presenterViewMock.showCurrenciesCompletionBlock = { expectation.fulfill() }
    presenter.presenterView = presenterViewMock

    wait(for: [expectation], timeout: 1)

    presenter.didDismiss()

    XCTAssertEqual(delegateMock.callsToDidDismiss, 1)
  }


  // MARK: -

  private static func makeCurrencies() -> Set<Currency> {
    [
      Currency(code: "EUR"),
      Currency(code: "JPY"),
      Currency(code: "USD")
    ]
  }

}
