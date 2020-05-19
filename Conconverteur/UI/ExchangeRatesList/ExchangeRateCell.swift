import UIKit

class ExchangeRateCell: UITableViewCell {

  @IBOutlet var currencyLabel: UILabel!
  @IBOutlet var amountLabel: UILabel!


  override func awakeFromNib() {
    amountLabel.setTextAlignmentToReverseNatural()
  }

}
