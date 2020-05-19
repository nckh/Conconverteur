import CoreData
import os.log

class CoreDataStorage: LocalStorage {

  private let container: NSPersistentContainer
  private var currencies: [Currency]?
  private var allExchangeRates = [Currency: ExchangeRates]()


  init(container: NSPersistentContainer) {
    self.container = container

    container.loadPersistentStores { _, error in
      guard error == nil else {
        os_log(.error, "Could not load the persistent store: %@", error!.localizedDescription)
        fatalError("Could not load the persistent store: \(error!.localizedDescription)")
      }
    }
  }

  convenience init() {
    let container = Self.makeContainer()

    self.init(container: container)
  }

  func fetchAnyBaseCurrency() -> Currency? {
    let request = ExchangeRateEntity.makeFetchRequest()
    request.fetchLimit = 1

    let entities: [ExchangeRateEntity]
    do {
      entities = try container.viewContext.fetch(request)
    } catch {
      os_log(.error, "CoreData error: %@", error.localizedDescription)
      return nil
    }

    guard let entity = entities.first else { return nil }

    return Currency(code: entity.base)
  }

  func fetchCurrencies() -> Set<Currency>? {
    guard let baseCurrency = fetchAnyBaseCurrency() else {
      os_log(.error, "Could not find any quotes in storage")
      return nil
    }

    let quoteCurrencies = fetchQuoteCurrencies(for: baseCurrency)
    return Set([[baseCurrency], quoteCurrencies].joined())
  }

  func fetchExchangeRates(for currency: Currency) -> ExchangeRates? {
    let request = ExchangeRateEntity.makeFetchRequest()
    let predicate = NSPredicate(format: "base == %@ AND quote != %@", currency.code, currency.code)
    request.predicate = predicate

    do {
      let managedObjects = try container.viewContext.fetch(request)
      return ExchangeRates(from: managedObjects)
    } catch {
      os_log(.error, "CoreData error: %@", error.localizedDescription)
      return nil
    }
  }

  func save(_ exchangeRates: ExchangeRates, completionHandler: (() -> Void)? = nil) {
    container.performBackgroundTask { context in
      context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      exchangeRates.insertNewObjects(into: context)

      do {
        try context.save()
      } catch {
        os_log(.error, "CoreData error: %@", error.localizedDescription)
      }

      completionHandler?()
    }
  }

  private func fetchQuoteCurrencies(for currency: Currency) -> [Currency] {
    let predicate = NSPredicate(format: "base == %@", currency.code)
    let request = ExchangeRateEntity.makeFetchRequest()
    request.predicate = predicate

    let entities: [ExchangeRateEntity]
    do {
      entities = try container.viewContext.fetch(request)
    } catch {
      os_log(.error, "CoreData error: %@", error.localizedDescription)
      return []
    }

    return entities.map { Currency(code: $0.quote) }
  }


  private static func makeContainer() -> NSPersistentContainer {
    NSPersistentContainer(name: "Model", managedObjectModel: Self.makeManagedObjectModel())
  }

  private static func makeManagedObjectModel() -> NSManagedObjectModel {
    guard let url = Bundle.current.url(forResource: "Model", withExtension: "momd") else {
      fatalError("Could not find Model file in bundle")
    }

    guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Could not initialize managed object model")
    }

    return managedObjectModel
  }

}


// MARK: -

private extension ExchangeRates {

  init?(from managedObjects: [ExchangeRateEntity]) {
    guard !managedObjects.isEmpty else { return nil }
    let firstObject = managedObjects.first!

    // Assuming all objects share the same date and base currency
    let date = firstObject.date
    let currency = Currency(code: firstObject.base)

    let quotes: [ExchangeRates.Quote] = managedObjects.map {
      ExchangeRates.Quote(
        currency: Currency(code: $0.quote),
        rate: $0.rate
      )
    }

    self.init(date: date, base: currency, quotes: quotes)
  }

  func insertNewObjects(into context: NSManagedObjectContext) {
    quotes.forEach { quote in
      let managedObject = ExchangeRateEntity(context: context)
      managedObject.base = base.code
      managedObject.date = date
      managedObject.quote = quote.currency.code
      managedObject.rate = quote.rate
    }
  }

}
