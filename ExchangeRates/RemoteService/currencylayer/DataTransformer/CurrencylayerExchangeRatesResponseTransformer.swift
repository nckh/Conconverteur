/// Transforms the response from currencylayer API into a `ExchangeRates` instance.
struct CurrencylayerExchangeRatesResponseTransformer: DataTransformer {

  func transform(_ response: CurrencylayerExchangeRatesResponse) -> ExchangeRates {
    let quotes: [ExchangeRates.Quote] = response.quotes.map { pair, rate in
      ExchangeRates.Quote(
        currency: Currency(code: String(pair.suffix(3))),
        rate: rate
      )
    }
    return ExchangeRates(date: response.date, base: response.base, quotes: quotes)
  }

}
