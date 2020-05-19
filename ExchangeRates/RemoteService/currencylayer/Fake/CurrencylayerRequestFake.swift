import Foundation
import os.log

/// A request downloading data from static JSON files located in the bundle.
class CurrencylayerRequestFake: RequestProtocol {

  private let fileName: String


  init(fileName: String) {
    self.fileName = fileName
  }

  func load(completionHandler: RequestProtocol.CompletionHandler?) {
    guard
      let url = Bundle.current.url(forResource: fileName, withExtension: "json"),
      let data = try? Data(contentsOf: url) else {
        completionHandler?(.failure(CurrencylayerRequestFakeError.localFileNotFound))
        return
    }

    os_log(.info, "Loaded data from %@", url.absoluteString)

    completionHandler?(.success(data))
  }

}
