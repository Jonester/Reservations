//
//  ReservationsViewController.swift
//  Reservations
//
//  Created by Chris Jones on 2019-11-20.
//  Copyright © 2019 Chris Jones. All rights reserved.
//

import UIKit

typealias AddReservationCompletion = ((Result<(), NSError>) -> ())

class ReservationsViewController: UITableViewController, AddReservationDelegate {

    let viewModel = ReservationsViewModel()
    private var reservations: [Reservation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        guard let fetchedReservations = Reservation.fetchReservations(in: container.viewContext) else { return }

        title = NSLocalizedString("Reservations Queue", comment: "")

        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReservation))
        navigationItem.rightBarButtonItem = addBarButtonItem
        let settingsBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settings))
        navigationItem.leftBarButtonItem = settingsBarButtonItem

        reservations = fetchedReservations.filter { $0.deletedAt == nil }

        let nib = UINib(nibName: "ReservationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReservationCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReservationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ReservationCell
        let reservation = reservations[indexPath.row]

        if reservation.deletedAt == nil {
            cell.nameLabel.text = NSLocalizedString(reservation.name, comment: "")
            cell.phoneNumberLabel.text = NSLocalizedString(reservation.phoneNumber, comment: "")
            cell.partySizeLabel.text = String(format: NSLocalizedString("%i", comment: ""), reservation.partySize)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reservation = reservations[indexPath.row]
        var deleteAction = UIContextualAction()
        let title = NSLocalizedString("Delete", comment: "")

        deleteAction = UIContextualAction.init(style: .normal, title: title, handler: { action, sourceView, completionHandler in
            reservation.deletedAt = Date()
            guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
            let fetchedReservations = Reservation.fetchReservations(in: container.viewContext) ?? self.reservations
            self.reservations = fetchedReservations.filter { $0.deletedAt == nil }
            tableView.reloadData()
        })

        deleteAction.backgroundColor = .red
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActionConfig.performsFirstActionWithFullSwipe = true

        return swipeActionConfig
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reservation = reservations[indexPath.row]
        var messageAction = UIContextualAction()
        let title = NSLocalizedString("Send Message", comment: "")

        messageAction = UIContextualAction.init(style: .normal, title: title, handler: { action, sourceView, completionHandler in

        })

        messageAction.backgroundColor = UIColor(red: 0.02, green: 0.33, blue: 0.43, alpha: 1)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [messageAction])
        swipeActionConfig.performsFirstActionWithFullSwipe = true

        return swipeActionConfig
    }

    func refreshTableView() {
        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let fetchedReservations = Reservation.fetchReservations(in: container.viewContext) ?? reservations
        reservations = fetchedReservations.filter { $0.deletedAt == nil }
        tableView.reloadData()

    }
}

private extension ReservationsViewController {
    @objc func addReservation() {
        let addReservationViewController = AddReservationViewController()
        let navController = UINavigationController(rootViewController: addReservationViewController)
        modalPresentationStyle = .formSheet
        addReservationViewController.preferredContentSize = CGSize(width: 1024, height: 300)
        addReservationViewController.delegate = self
        present(navController, animated: true, completion: nil)
    }

    @objc func settings() {
        let settingsViewController = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsViewController)
        modalPresentationStyle = .formSheet
        settingsViewController.preferredContentSize = CGSize(width: 1024, height: 300)
        present(navController, animated: true, completion: nil)
    }
}
