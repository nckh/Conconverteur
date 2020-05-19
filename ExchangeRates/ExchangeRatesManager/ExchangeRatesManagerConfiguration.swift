import Foundation

public class ExchangeRatesManagerConfiguration {

  var localStorage: LocalStorage {
    localStorageLocation.storage()
  }

  var remoteService: RemoteService {
    remoteServiceProvider.service()
  }

  var ratesExpirationTime: TimeInterval = 30 * 60

  private let localStorageLocation: LocalStorageLocation
  private let remoteServiceProvider: RemoteServiceProvider


  public init(localStorageLocation: LocalStorageLocation, remoteServiceProvider: RemoteServiceProvider) {
    self.localStorageLocation = localStorageLocation
    self.remoteServiceProvider = remoteServiceProvider
  }


  // MARK: -

  public enum LocalStorageLocation {

    case inMemory, coreData
    case custom(LocalStorage)

    func storage() -> LocalStorage {
      switch self {
      case .inMemory: return InMemoryStorage()
      case .coreData: return CoreDataStorage()
      case let .custom(storage): return storage
      }
    }

  }

  public enum RemoteServiceProvider {

    case currencylayer(apiKey: String, useHTTPS: Bool)
    case currencylayerFake
    case custom(RemoteService)

    func service() -> RemoteService {
      switch self {
      case let .currencylayer(apiKey, useHTTPS):
        return CurrencylayerService(apiKey: apiKey, useHTTPS: useHTTPS)

      case .currencylayerFake: return CurrencylayerServiceFake()
      case let .custom(service): return service
      }
    }

  }

}
