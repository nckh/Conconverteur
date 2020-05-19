import XCTest
import CoreData
@testable import ExchangeRates

class CoreDataStorageTests: XCTestCase {

  private var container: NSPersistentContainer!
  private var storage: CoreDataStorage!


  override func setUpWithError() throws {
    container = Self.makeContainer()
    storage = CoreDataStorage(container: container)
  }

  func testFetchCurrencies() throws {
    try insertExchangeRate(base: "AAA", quote: "BBB", rate: 1.4)
    try insertExchangeRate(base: "AAA", quote: "CCC", rate: 0.124)
    try insertExchangeRate(base: "AAA", quote: "DDD", rate: 12_432)
    try insertExchangeRate(base: "BBB", quote: "AAA", rate: 75)
    try insertExchangeRate(base: "BBB", quote: "CCC", rate: 92)
    try insertExchangeRate(base: "BBB", quote: "DDD", rate: 96)

    let currencies = storage.fetchCurrencies()

    XCTAssertNotNil(currencies)
    if currencies == nil { return }
    XCTAssertEqual(currencies!.count, 4)
    XCTAssertTrue(currencies!.contains("AAA"))
    XCTAssertTrue(currencies!.contains("BBB"))
    XCTAssertTrue(currencies!.contains("CCC"))
    XCTAssertTrue(currencies!.contains("DDD"))
  }

  func testFetchExchangeRates() throws {
    let date = Date(timeIntervalSince1970: 1234)
    try insertExchangeRate(base: "AAA", quote: "BBB", rate: 1.4, date: date)
    try insertExchangeRate(base: "AAA", quote: "CCC", rate: 0.124, date: date)
    try insertExchangeRate(base: "BBB", quote: "DDD", rate: 12_432, date: date)

    let exchangeRates = storage.fetchExchangeRates(for: Currency(code: "AAA"))

    XCTAssertNotNil(exchangeRates)
    if exchangeRates == nil { return }
    XCTAssertEqual(exchangeRates!.date, date)
    XCTAssertEqual(exchangeRates!.quotes.count, 2)
    XCTAssertTrue(exchangeRates!.quotes.contains(ExchangeRates.Quote(currency: "BBB", rate: 1.4)))
    XCTAssertTrue(exchangeRates!.quotes.contains(ExchangeRates.Quote(currency: "CCC", rate: 0.124)))
  }

  func testFetchExchangeRatesExcludingBaseCurrency() throws {
    try insertExchangeRate(base: "AAA", quote: "AAA", rate: 1)
    try insertExchangeRate(base: "AAA", quote: "BBB", rate: 1.4)
    try insertExchangeRate(base: "AAA", quote: "CCC", rate: 0.124)
    try insertExchangeRate(base: "BBB", quote: "DDD", rate: 12_432)

    let exchangeRates = storage.fetchExchangeRates(for: Currency(code: "AAA"))

    XCTAssertNotNil(exchangeRates)
    if exchangeRates == nil { return }
    XCTAssertEqual(exchangeRates!.quotes.count, 2)
    XCTAssertTrue(exchangeRates!.quotes.contains(ExchangeRates.Quote(currency: "BBB", rate: 1.4)))
    XCTAssertTrue(exchangeRates!.quotes.contains(ExchangeRates.Quote(currency: "CCC", rate: 0.124)))
  }

  func testSaveExchangeRates() throws {
    let date = Date(timeIntervalSince1970: 5678)
    let exchangeRates = ExchangeRates(date: date, base: "AAA", quotes: [
      ExchangeRates.Quote(currency: "BBB", rate: 1.4),
      ExchangeRates.Quote(currency: "CCC", rate: 0.124)
    ])
    let expectation = XCTestExpectation()

    storage.save(exchangeRates) { expectation.fulfill() }

    wait(for: [expectation], timeout: 1)

    let request = NSFetchRequest<ExchangeRateEntity>(entityName: "ExchangeRateEntity")
    request.sortDescriptors = [NSSortDescriptor(key: "quote", ascending: true)]
    let entities = try container.viewContext.fetch(request)

    XCTAssertEqual(entities.count, 2)
    if entities.count != 2 { return }
    XCTAssertEqual(entities[0].base, "AAA")
    XCTAssertEqual(entities[0].quote, "BBB")
    XCTAssertEqual(entities[0].rate, 1.4)
    XCTAssertEqual(entities[0].date, date)
    XCTAssertEqual(entities[1].base, "AAA")
    XCTAssertEqual(entities[1].quote, "CCC")
    XCTAssertEqual(entities[1].rate, 0.124)
    XCTAssertEqual(entities[1].date, date)
  }


  // MARK: -

  private func insertExchangeRate(base: String, quote: String, rate: Double, date: Date = Date()) throws {
    let managedObject = NSEntityDescription.insertNewObject(forEntityName: "ExchangeRateEntity", into: container.viewContext)
    managedObject.setValue(base, forKey: "base")
    managedObject.setValue(quote, forKey: "quote")
    managedObject.setValue(rate, forKey: "rate")
    managedObject.setValue(date, forKey: "date")
    try container.viewContext.save()
  }

  private static func makeContainer() -> NSPersistentContainer {
    let container = NSPersistentContainer(name: "Model", managedObjectModel: Self.makeManagedObjectModel())

    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]

    return container
  }

  private static func makeManagedObjectModel() -> NSManagedObjectModel {
    guard let bundle = Bundle(identifier: "com.nckh.ExchangeRates") else {
      fatalError("Could not find app bundle")
    }

    guard let url = bundle.url(forResource: "Model", withExtension: "momd") else {
      fatalError("Could not find Model file in bundle")
    }

    guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Could not initialize managed object model")
    }

    return managedObjectModel
  }

}
