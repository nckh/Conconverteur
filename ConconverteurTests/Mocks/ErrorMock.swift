import Foundation

enum ErrorMock: Error {
  case whatever
}


extension ErrorMock: LocalizedError {

  var errorDescription: String? { "Some error happened." }

}
