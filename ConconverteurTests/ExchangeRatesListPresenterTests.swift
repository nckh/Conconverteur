import XCTest
@testable import ExchangeRates

class ExchangeRatesListPresenterTests: XCTestCase {

  private var presenter: ExchangeRatesListPresenter!
  private var presenterViewMock: ExchangeRatesListPresenterViewMock!
  private var managerMock: ExchangeRatesManagerMock!

  override func setUpWithError() throws {
    managerMock = ExchangeRatesManagerMock()
    managerMock.exchangeRatesResult = .success(Self.makeExchangeRates())

    presenter = ExchangeRatesListPresenter(exchangeRatesManager: managerMock, baseCurrency: "USD", amount: 1)
    presenterViewMock = ExchangeRatesListPresenterViewMock()
  }

  func testDontFetchUntilSceneActivates() throws {
    presenter.presenterView = presenterViewMock

    XCTAssertEqual(managerMock.callsToFetchExchangeRates.count, 0)
  }

  func testFetchExchangeRatesWhenSceneActivates() throws {
    let expectation = XCTestExpectation()
    presenterViewMock.updateExchangeRatesListCompletionBlock = { expectation.fulfill() }
    presenter.presenterView = presenterViewMock

    presenterViewMock.triggerActivateNotification()

    wait(for: [expectation], timeout: 1)

    XCTAssertEqual(managerMock.callsToFetchExchangeRates.count, 1)
    if managerMock.callsToFetchExchangeRates.count != 1 { return }
    XCTAssertEqual(managerMock.callsToFetchExchangeRates[0], "USD")
  }

  func testShowExchangeRatesWhenSceneActivates() throws {
    let expectation = XCTestExpectation()
    presenterViewMock.updateExchangeRatesListCompletionBlock = { expectation.fulfill() }
    presenter.presenterView = presenterViewMock

    presenterViewMock.triggerActivateNotification()

    wait(for: [expectation], timeout: 1)

    let call = presenterViewMock.callsToUpdateExchangeRatesList[0]
    XCTAssertEqual(call.date, Date(timeIntervalSince1970: 1234))
    XCTAssertEqual(call.list.count, 2)
    if call.list.count != 2 { return }
    XCTAssertEqual(call.list[0].currency, "Euro")
    XCTAssertEqual(call.list[0].amount, "€1.40")
    XCTAssertEqual(call.list[1].currency, "Japanese Yen")
    XCTAssertEqual(call.list[1].amount, "¥0.12")
  }

  func testFetchExchangeRatesAfterCurrencyChange() throws {
    let expectation = XCTestExpectation()
    presenterViewMock.updateExchangeRatesListCompletionBlock = { expectation.fulfill() }
    presenter.presenterView = presenterViewMock
    presenterViewMock.triggerActivateNotification()
    managerMock.callsToFetchExchangeRates = []

    presenter.baseCurrency = "EUR"

    wait(for: [expectation], timeout: 1)

    XCTAssertEqual(managerMock.callsToFetchExchangeRates.count, 1)
    if managerMock.callsToFetchExchangeRates.count != 1 { return }
    XCTAssertEqual(managerMock.callsToFetchExchangeRates[0], "EUR")

  }

  func testEditIntegerAmount() throws {
    presenter.didEditAmount("123")

    XCTAssertEqual(presenter.amount, 123)
  }

  func testEditDecimalAmount() throws {
    presenter.didEditAmount("123.45")

    XCTAssertEqual(presenter.amount, 123.45)
  }

  func testRefreshListAfterUpdatingAmount() throws {
    presenter.presenterView = presenterViewMock
    presenterViewMock.triggerActivateNotification()

    let expectation = XCTestExpectation()
    presenterViewMock.updateExchangeRatesListCompletionBlock = { expectation.fulfill() }
    wait(for: [expectation], timeout: 1)

    presenterViewMock.callsToUpdateExchangeRatesList = []
    presenter.didEditAmount("10")

    let call = presenterViewMock.callsToUpdateExchangeRatesList[0]
    XCTAssertTrue(call.list.contains { $0.amount == "€14.00" })
    XCTAssertTrue(call.list.contains { $0.amount == "¥1.24" })
  }

  func testCallDelegateAfterTappingCurrency() throws {
    let delegateMock = ExchangeRatesListPresenterDelegateMock()
    presenter.delegate = delegateMock

    XCTAssertEqual(delegateMock.callsToDidTapCurrency, 0)

    presenter.didTapCurrency()

    XCTAssertEqual(delegateMock.callsToDidTapCurrency, 1)
  }

  func testShowFetchError() throws {
    managerMock.exchangeRatesResult = .failure(ErrorMock.whatever)
    let expectation = XCTestExpectation()
    presenterViewMock.presentAlertErrorCompletionBlock = { expectation.fulfill() }
    presenter.presenterView = presenterViewMock

    presenterViewMock.triggerActivateNotification()

    wait(for: [expectation], timeout: 1)

    XCTAssertEqual(presenterViewMock.callsToPresentAlertError.count, 1)
    if presenterViewMock.callsToPresentAlertError.count != 1 { return }
    let call = presenterViewMock.callsToPresentAlertError[0]
    XCTAssertEqual(call, "Some error happened.")
  }


  // MARK: -

  private static func makeExchangeRates() -> ExchangeRates {
    let date = Date(timeIntervalSince1970: 1234)
    return ExchangeRates(date: date, base: "USD", quotes: [
      ExchangeRates.Quote(currency: "EUR", rate: 1.4),
      ExchangeRates.Quote(currency: "JPY", rate: 0.124),
      ExchangeRates.Quote(currency: "USD", rate: 1)
    ])
  }

}
