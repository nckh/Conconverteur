import Foundation
import CoreData

extension ExchangeRateEntity {

  @nonobjc class func makeFetchRequest() -> NSFetchRequest<ExchangeRateEntity> {
    return NSFetchRequest<ExchangeRateEntity>(entityName: "ExchangeRateEntity")
  }

  @NSManaged var base: String
  @NSManaged var quote: String
  @NSManaged var rate: Double
  @NSManaged var date: Date

}
