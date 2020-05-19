import Foundation

enum CurrencylayerRequestFakeError: Error {
  case localFileNotFound
}


extension CurrencylayerRequestFakeError: LocalizedError {

  var errorDescription: String? {
    switch self {
    case .localFileNotFound:
      return NSLocalizedString("Could not find payload file in bundle.", bundle: .current, comment: "Local file loading error")
    }
  }

}
