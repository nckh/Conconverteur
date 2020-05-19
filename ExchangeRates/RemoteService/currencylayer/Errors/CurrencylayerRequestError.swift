import Foundation

enum CurrencylayerRequestError: Error {
  case loadingError(String)
  case unknown
}


extension CurrencylayerRequestError: LocalizedError {

  var errorDescription: String? {
    switch self {
    case let .loadingError(message):
      let localizedString = NSLocalizedString("Could not fetch rates from API.\n%@", bundle: .current, comment: "Loading error when calling API") as NSString
      return NSString.localizedStringWithFormat(localizedString, message) as String

    case .unknown:
      return NSLocalizedString("An unknown error happened.", bundle: .current, comment: "Unknown error with data from API")
    }
  }

}
