import UIKit

class ExchangeRatesListViewController: UIViewController {

  private let presenter: ExchangeRatesListPresenter

  private var dataSource: ExchangeRatesListDataSource? {
    didSet {
      tableView.dataSource = dataSource
      tableView.reloadData()
    }
  }

  private var observationToken: NSObjectProtocol?

  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var amountTextField: UITextField!
  @IBOutlet private var decimalPadToolbar: UIToolbar!
  @IBOutlet private var doneButtonBarButtonItem: UIBarButtonItem!
  @IBOutlet private var currencyButton: UIButton!


  init(presenter: ExchangeRatesListPresenter) {
    self.presenter = presenter

    super.init(nibName: nil, bundle: nil)
  }

  init?(coder: NSCoder, presenter: ExchangeRatesListPresenter) {
    self.presenter = presenter

    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    amountTextField.inputAccessoryView = decimalPadToolbar
    doneButtonBarButtonItem.target = self
    doneButtonBarButtonItem.action = #selector(closeKeyboard)
    amountTextField.setTextAlignmentToReverseNatural()

    amountTextField.delegate = self

    presenter.presenterView = self
  }

  deinit {
    if let token = observationToken {
      NotificationCenter.default.removeObserver(token)
    }
  }

}


// MARK: -

extension ExchangeRatesListViewController {

  @IBAction private func closeKeyboard() {
    amountTextField.resignFirstResponder()
  }

  @IBAction private func didEditAmount(textField: UITextField) {
    presenter.didEditAmount(textField.text)
  }

  @IBAction private func didTapCurrency() {
    presenter.didTapCurrency()
  }

}


// MARK: - ExchangeRatesListPresenterViewable

extension ExchangeRatesListViewController: ExchangeRatesListPresenterViewable {

  func setCurrency(text: String?) {
    currencyButton.setTitle(text, for: .normal)
  }

  func setAmount(text: String?) {
    amountTextField.text = text
  }

  func updateExchangeRatesList(date: Date, list: [ExchangeRatesListPresenterViewable.PresentedExchangeRate]) {
    dataSource = ExchangeRatesListDataSource(date: date, list: list)
  }

  func presentAlertError(message: String) {
    let alert = ControllerFactory.makeAlertViewController(message: message)
    present(alert, animated: true)
  }

  func addDidActivateNotificationObserver(_ block: (() -> Void)?) {
    observationToken = NotificationCenter.default.addObserver(forName: UIScene.didActivateNotification, object: nil, queue: nil) { _ in
      block?()
    }
  }

}


// MARK: - UITextFieldDelegate

extension ExchangeRatesListViewController: UITextFieldDelegate {

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard
      let text = textField.text,
      text.count < Constant.maxDigits else {
        return false
    }

    return true
  }

}
