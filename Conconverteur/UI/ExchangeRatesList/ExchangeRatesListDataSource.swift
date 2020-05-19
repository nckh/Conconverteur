import UIKit

class ExchangeRatesListDataSource: NSObject {

  private let date: Date
  private let list: [ExchangeRatesListPresenterViewable.PresentedExchangeRate]


  init(date: Date, list: [ExchangeRatesListPresenterViewable.PresentedExchangeRate]) {
    self.date = date
    self.list = list
  }

}


// MARK: -

extension ExchangeRatesListDataSource: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int { 1 }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    list.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as? ExchangeRateCell else {
      fatalError("Could not find cell with identifier \"\(Self.cellIdentifier)\" in storyboard")
    }

    let item = list[indexPath.row]
    cell.currencyLabel?.text = item.currency
    cell.amountLabel?.text = item.amount
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    Self.dateFormatter.string(from: date)
  }


  private static let cellIdentifier = Constant.CellReuseIdentifier.exchangeRate

  private static var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
  }()

}
