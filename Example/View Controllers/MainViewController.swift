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

    private var transactions: [[Transaction]] = [[], []] {
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

    private lazy var transactionsController = TransactionsController()

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

    private func updatePendingTransactions(from response: PaginatedResponse<Transaction>) {

        transactions[0] = response.list.filter { $0.state == .pending }

    }

    private func updateApprovedTransactions(from response: PaginatedResponse<Transaction>) {

        transactions[1] = response.list.filter { $0.state == .approved }

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

        cell.textLabel?.text = {

            let payer = transaction.consumerName
            let type = transaction.type?.rawValue

            return "\(payer ?? "Unknown") (\(type ?? "unknown type"))"

        }()

        cell.detailTextLabel?.text = {

            let amount = NSDecimalNumber(value: transaction.amount).dividing(by: NSDecimalNumber(value: 100))

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

            self?.updateStateOfTransaction(at: indexPath, to: .approved)

        }

        let cancelAction = UITableViewRowAction(style: .destructive, title: "Cancel") { [weak self] (_, indexPath) in

            self?.updateStateOfTransaction(at: indexPath, to: .cancelled)

        }

        return [confirmAction, cancelAction]

    }

    private func rowActionsForApprovedTransaction(at index: Int) -> [UITableViewRowAction] {

        guard transactions[1][index].type == .c2b else {
            return []
        }

        let refundAction = UITableViewRowAction(style: .normal, title: "Refund") { [weak self] (_, indexPath) in

            self?.refundTransaction(at: indexPath)

        }

        return [refundAction]

    }

}

// MARK: - Transaction update/refund
extension MainViewController {

    private func updateStateOfTransaction(at indexPath: IndexPath, to newState: TransactionState) {

        guard indexPath.section == 0, transactions[0].count > indexPath.row else {
            return
        }

        let transaction = transactions[indexPath.section][indexPath.row]

        _ = TransactionsController().updateState(of: transaction.id, with: newState, completionHandler: { [weak self] (_, error) in

            guard error == nil else {
                self?.failUpdate(of: transaction, to: newState)
                return
            }

            self?.refreshTransactions(nil)

        })

    }

    private func failUpdate(of transaction: Transaction, to newState: TransactionState) {

        let errorController = UIAlertController(title: "Error",
                                                message: "Couldn't update transaction \(transaction.id) state to \(newState.rawValue)",
                                                preferredStyle: .alert)

        errorController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(errorController, animated: true, completion: nil)

    }

    private func refundTransaction(at indexPath: IndexPath) {

        guard indexPath.section == 1, transactions[1].count > indexPath.row else {
            return
        }

        let transaction = transactions[indexPath.section][indexPath.row]

        _ = TransactionsController().refund(transactionId: transaction.id) { [weak self] (_, error) in

            guard error == nil else {
                self?.failRefund(of: transaction)
                return
            }

            self?.refreshTransactions(nil)

        }

    }

    private func failRefund(of transaction: Transaction) {

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

        let analytics = TransactionsListRequest.Analytics(softwareHouse: "Satispay",
                                                          softwareName: "SatispayInStore example app",
                                                          softwareVersion: "1.0",
                                                          deviceInfo: UIDevice.current.modelName)

        group.enter()

        _ = transactionsController.transactions(filter: "proposed", analytics: analytics) { [weak self] (response, _) in

            if let response = response {
                self?.updatePendingTransactions(from: response)
            }

            group.leave()

        }

        group.enter()

        _ = transactionsController.transactions(analytics: analytics) { [weak self] (response, _) in

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
