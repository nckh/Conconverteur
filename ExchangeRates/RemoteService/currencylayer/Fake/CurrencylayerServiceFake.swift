import Foundation

/// A fake service that downloads data from static JSON files located in the bundle.
class CurrencylayerServiceFake: CurrencylayerServiceProtocol {

  let operationQueue = OperationQueue()
  let requestFactory: RequestFactoryProtocol = CurrencylayerRequestFactoryFake()

}
