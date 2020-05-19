import UIKit
import ExchangeRates

class CurrencySelectorViewController: UIViewController {

  private let presenter: CurrencySelectorPresenter

  private var dataSource: CurrencySelectorDataSource? {
    didSet {
      tableView.dataSource = dataSource
      tableView.reloadData()
    }
  }

  private var tableView: UITableView! { view as? UITableView }


  init(presenter: CurrencySelectorPresenter) {
    self.presenter = presenter

    super.init(nibName: nil, bundle: nil)
  }

  init?(coder: NSCoder, presenter: CurrencySelectorPresenter) {
    self.presenter = presenter

    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self
    presenter.presenterView = self
  }

}


// MARK: -

extension CurrencySelectorViewController {

  @IBAction private func dismiss() {
    presenter.didDismiss()
  }

}


// MARK: - CurrencySelectorPresenterViewable

extension CurrencySelectorViewController: CurrencySelectorPresenterViewable {

  func showCurrencies(_ currencies: [PresentedCurrency], selectedIndex: Int) {
    dataSource = CurrencySelectorDataSource(currencies: currencies, selectedIndex: selectedIndex)
  }

}


// MARK: - UITableViewDelegate

extension CurrencySelectorViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.didSelectCell(at: indexPath.row)
  }

}
