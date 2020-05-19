import Foundation

extension String {

  var firstLetterCapitalized: String {
    prefix(1).capitalized + dropFirst()
  }

}
