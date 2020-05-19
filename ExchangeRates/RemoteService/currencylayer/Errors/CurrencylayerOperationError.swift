import Foundation

enum CurrencylayerOperationError: Error {
  case apiError(CurrencylayerErrorResponse.Error)
  case couldNotDecode
}


extension CurrencylayerOperationError: LocalizedError {

  var errorDescription: String? {
    switch self {
    case let .apiError(error):
      let localizedString = NSLocalizedString("%@\nCode: %d", bundle: .current, comment: "API error") as NSString
      return NSString.localizedStringWithFormat(localizedString, error.info, error.code) as String

    case .couldNotDecode:
      return NSLocalizedString("Could not decode response from API.", bundle: .current, comment: "API response parsing error")
    }
  }

}
