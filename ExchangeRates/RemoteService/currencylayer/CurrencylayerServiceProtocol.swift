import Foundation

protocol CurrencylayerServiceProtocol: RemoteService {

  var requestFactory: RequestFactoryProtocol { get }

}


extension CurrencylayerServiceProtocol {

  func makeFetchExchangeRatesOperation(currency: Currency) -> QueryOperation<ExchangeRates> {
    let request = requestFactory.makeExchangeRatesRequest(for: currency)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970

    let dataTransformer = CurrencylayerExchangeRatesResponseTransformer()

    return CurrencylayerOperation(request: request, decoder: decoder, dataTransformer: dataTransformer)
  }

}
