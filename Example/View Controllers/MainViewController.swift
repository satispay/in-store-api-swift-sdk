//
//  MainViewController.swift
//  Example
//
//  Created by Pierluigi D'Andrea on 23/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import SatispayInStore
import UIKit

class MainViewController: UITableViewController {

    private var transactions: [[Payment]] = [[], []] {
        didSet {
            var sectionsToReload = IndexSet()

            for (section, newTransactions) in transactions.enumerated() where oldValue[section] != newTransactions {
                sectionsToReload.insert(section)
            }

            guard !sectionsToReload.isEmpty else {
                return
            }

            tableView.beginUpdates()
            tableView.reloadSections(sectionsToReload, with: .automatic)
            tableView.endUpdates()
        }
    }

    private lazy var paymentsController = PaymentsController()

    private lazy var currencyFormatter: NumberFormatter = {

        let locale = Locale(identifier: "it_IT")

        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency

        if let currencySymbol = (locale as NSLocale).object(forKey: NSLocale.Key.currencySymbol) as? String {
            formatter.currencySymbol = currencySymbol
        }

        if let currencyCode = (locale as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String {
            formatter.currencyCode = currencyCode
        }

        return formatter

    }()

    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.refreshControl = {

            let control = UIRefreshControl()
            control.addTarget(self, action: #selector(refreshTransactions(_:)), for: .valueChanged)

            return control

        }()

        refreshTransactions(nil)

    }

}

// MARK: - ProfileRequiring
extension MainViewController: ProfileRequiring {

    func configure(with profile: Profile) {
        title = profile.shop.name
    }

}

// MARK: - Updating
extension MainViewController {

    private func updatePendingTransactions(from response: PaginatedDataResponse<Payment>) {
        transactions[0] = response.data.filter { $0.status == .pending }
    }

    private func updateApprovedTransactions(from response: PaginatedDataResponse<Payment>) {
        transactions[1] = response.data.filter { $0.status == .accepted }
    }

}

// MARK: - UITableViewDataSource
extension MainViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell

        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "PendingTransactionCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        }

        let transaction = transactions[indexPath.section][indexPath.row]

        cell.textLabel?.text = "\(transaction.sender.name ?? "Unknown") (\(transaction.type ?? "unknown type"))"
        cell.detailTextLabel?.text = {
            let amount = NSDecimalNumber(value: transaction.amountUnit).dividing(by: NSDecimalNumber(value: 100))
            return currencyFormatter.string(from: amount)
        }()

        return cell

    }

}

// MARK: - UITableViewDelegate
extension MainViewController {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 0:
            return "Pending"
        case 1:
            return "Approved"
        default:
            return nil
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        switch indexPath.section {
        case 0:
            return rowActionsForPendingTransaction()
        default:
            return rowActionsForApprovedTransaction(at: indexPath.row)
        }

    }

    private func rowActionsForPendingTransaction() -> [UITableViewRowAction] {

        let confirmAction = UITableViewRowAction(style: .normal, title: "Confirm") { [weak self] (_, indexPath) in
            self?.updateStateOfPayment(at: indexPath, action: .accept)
        }

        let cancelAction = UITableViewRowAction(style: .destructive, title: "Cancel") { [weak self] (_, indexPath) in
            self?.updateStateOfPayment(at: indexPath, action: .cancel)
        }

        return [confirmAction, cancelAction]

    }

    private func rowActionsForApprovedTransaction(at index: Int) -> [UITableViewRowAction] {

        guard transactions[1][index].type == "TO_BUSINESS" else {
            return []
        }

        let refundAction = UITableViewRowAction(style: .normal, title: "Refund") { [weak self] (_, indexPath) in
            self?.refundTransaction(at: indexPath)
        }

        return [refundAction]

    }

}

// MARK: - Payment update/refund
extension MainViewController {

    private func updateStateOfPayment(at indexPath: IndexPath, action: PaymentUpdateAction) {

        guard indexPath.section == 0, transactions[0].count > indexPath.row else {
            return
        }

        let transaction = transactions[indexPath.section][indexPath.row]

        _ = PaymentsController().updatePayment(id: transaction.id, action: action, completionHandler: { [weak self] (_, error) in

            guard error == nil else {
                self?.failUpdate(of: transaction, action: action)
                return
            }

            self?.refreshTransactions(nil)

        })

    }

    private func failUpdate(of transaction: Payment, action: PaymentUpdateAction) {

        let errorController = UIAlertController(title: "Error",
                                                message: "Couldn't update payment \(transaction.id) with action \(action.rawValue)",
                                                preferredStyle: .alert)

        errorController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(errorController, animated: true, completion: nil)

    }

    private func refundTransaction(at indexPath: IndexPath) {

        guard indexPath.section == 1, transactions[1].count > indexPath.row else {
            return
        }

        let transaction = transactions[indexPath.section][indexPath.row]

        _ = paymentsController.createPayment(flow: .refund,
                                             amountUnit: transaction.amountUnit,
                                             currency: transaction.currency,
                                             expirationDate: nil,
                                             metadata: nil,
                                             callbackURL: nil,
                                             parentPaymentUid: transaction.id,
                                             idempotencyKey: UUID().uuidString) { [weak self] (_, error) in

            guard error == nil else {
                self?.failRefund(of: transaction)
                return
            }

            self?.refreshTransactions(nil)

        }

    }

    private func failRefund(of transaction: Payment) {

        let errorController = UIAlertController(title: "Error",
                                                message: "Couldn't refund transaction \(transaction.id)",
                                                preferredStyle: .alert)

        errorController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(errorController, animated: true, completion: nil)

    }

}

// MARK: - Refreshing
extension MainViewController {

    @objc func refreshTransactions(_ refreshControl: UIRefreshControl?) {

        let group = DispatchGroup()

        let analytics = PaymentsListRequest.Analytics(softwareHouse: "Satispay",
                                                          softwareName: "SatispayInStore example app",
                                                          softwareVersion: "1.0",
                                                          deviceInfo: UIDevice.current.modelName)

        group.enter()

        _ = paymentsController.payments(status: .pending, analytics: analytics) { [weak self] (response, _) in

            if let response = response {
                self?.updatePendingTransactions(from: response)
            }

            group.leave()

        }

        group.enter()

        _ = paymentsController.payments(analytics: analytics) { [weak self] (response, _) in

            if let response = response {
                self?.updateApprovedTransactions(from: response)
            }

            group.leave()

        }

        group.notify(queue: .main) {
            refreshControl?.endRefreshing()
        }

    }

}
