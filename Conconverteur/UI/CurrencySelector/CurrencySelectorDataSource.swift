import UIKit

class CurrencySelectorDataSource: NSObject {

  private let currencies: [CurrencySelectorPresenterViewable.PresentedCurrency]
  private let selectedIndex: Int


  init(currencies: [CurrencySelectorPresenterViewable.PresentedCurrency], selectedIndex: Int) {
    self.currencies = currencies
    self.selectedIndex = selectedIndex

    super.init()
  }

  private static let cellIdentifier = Constant.CellReuseIdentifier.currency

}


// MARK: -

extension CurrencySelectorDataSource: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int { 1 }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    currencies.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) else {
      fatalError("Could not find cell with identifier \"\(Self.cellIdentifier)\" in storyboard")
    }

    let currency = currencies[indexPath.row]
    cell.textLabel?.text = currency.name
    cell.detailTextLabel?.text = currency.code
    cell.accessoryType = (indexPath.row == selectedIndex) ? .checkmark : .none
    return cell
  }

}
