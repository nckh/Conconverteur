import UIKit

protocol AlignableLabel {
  var textAlignment: NSTextAlignment { get set }
  var semanticContentAttribute: UISemanticContentAttribute { get set }
}


extension AlignableLabel {

  mutating func setTextAlignmentToReverseNatural() {
    let layoutDirection = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
    if layoutDirection == .rightToLeft {
      textAlignment = .left
    }
  }

}

extension UILabel: AlignableLabel {}
extension UITextField: AlignableLabel {}
