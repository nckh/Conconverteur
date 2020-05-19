import Foundation

/// A value that represents a currency.
public struct Currency: Equatable, Hashable {

  public typealias Code = String

  public let code: Code


  public init(code: Code) {
    self.code = code
  }


  private static let availableLocales: [String: Locale] = {
    var list = [String: Locale]()

    for identifier in Locale.availableIdentifiers {
      let locale = Locale(identifier: identifier)
      guard let code = locale.currencyCode else { continue }
      list[code] = locale
    }

    return list
  }()

}


// MARK: -
extension Currency {

  public var locale: Locale? { Self.availableLocales[code] }

  public var localizedName: String {
    Locale.current.localizedString(forCurrencyCode: code) ??
      NSLocalizedString(code, tableName: "Currencies", bundle: .current, comment: "")
  }

  public func localizedAmountWithCurrencySymbol(_ amount: Double) -> String {
    let formatter = Self.makeCurrencyFormatter()
    formatter.currencySymbol = locale?.currencySymbol ?? code
    return formatter.string(from: amount as NSNumber) ?? String(amount)
  }


  private static func makeCurrencyFormatter(for locale: Locale = .current) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    return formatter
  }

}


// MARK: - Decodable

extension Currency: Decodable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let code = try container.decode(String.self)
    self = Currency(code: code)
  }

}


// MARK: - ExpressibleByStringLiteral

extension Currency: ExpressibleByStringLiteral {

  public init(stringLiteral value: StringLiteralType) {
    self.init(code: value)
  }

}
