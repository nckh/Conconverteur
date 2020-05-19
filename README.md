# Conconverteur

A simple iOS project to experiment with MVP and Coordinator patterns.
Oh and it's a currency converter by the way.

## Info.plist keys
* `CurrencylayerAPIKey`: a currencylayer API key. [Create one for free here](https://currencylayer.com/product).
* `UseHTTPS`: call currencylayer API with HTTPS calls. Only available on currencylayer paid plans.
* `UseFakeData`: fetch exchange rates from static JSON files located in `ExchangeRates/RemoteService/currencylayer/Fake/Payloads/`, instead of the currencylayer API.
