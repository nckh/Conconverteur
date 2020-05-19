protocol RequestFactoryProtocol {

  func makeExchangeRatesRequest(for currency: Currency) -> RequestProtocol

}
