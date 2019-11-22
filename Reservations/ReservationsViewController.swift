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
        setUpView()
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
        return 120
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = reservations[sourceIndexPath.row]
        movedObject.index = Int16(destinationIndexPath.row)
        let displacedObject = reservations[destinationIndexPath.row]
        displacedObject.index = Int16(sourceIndexPath.row)
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        reservations.remove(at: sourceIndexPath.row)
        reservations.insert(movedObject, at: destinationIndexPath.row)
        do {
            try context.save()
        } catch {
            print("oops")
        }
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reservation = reservations[indexPath.row]
        var deleteAction = UIContextualAction()
        let title = NSLocalizedString("Delete", comment: "")

        deleteAction = UIContextualAction.init(style: .normal, title: title, handler: { action, sourceView, completionHandler in
            reservation.deletedAt = Date()
            reservation.index = -1
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
            do {
                try context.save()
            } catch {
                print("oops")
            }
            Reservation.resetIndex(in: context)
            self.refreshTableView()
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
            reservation.messageSentAt = Date()
            let settings = Settings.fetchSettings(in: ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!)
            guard let setting = settings?.first else { return }
            let phone = reservation.phoneNumber
            let message = setting.message
            let url = URL(string: "https://notifications-hyeah.herokuapp.com/message")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = "phone=1\(phone)&message=\(message)".data(using: .utf8)

            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error: \(String(describing: error))")
                    // handle error
                    return
                }
                if let data = data, let responseDetails = String(data: data, encoding: .utf8) {
                    print("Response: \(responseDetails)")
                    // handle success
                } else {
                    // handle error
                }
            }).resume()
            self.refreshTableView()
        })

        messageAction.backgroundColor = UIColor(red: 0.02, green: 0.33, blue: 0.43, alpha: 1)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [messageAction])
        swipeActionConfig.performsFirstActionWithFullSwipe = true

        return swipeActionConfig
    }

    func refreshTableView() {
        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        let fetchedReservations = Reservation.fetchReservations(in: container.viewContext) ?? reservations
        reservations = fetchedReservations.filter { $0.deletedAt == nil && $0.messageSentAt == nil }
        tableView.reloadData()
    }
}

private extension ReservationsViewController {
    
    func setUpView() {
        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        guard let fetchedReservations = Reservation.fetchActiveReservations(in: container.viewContext) else { return }
        reservations = fetchedReservations
        
        title = NSLocalizedString("Reservations Queue", comment: "")

        let settingsBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settings))
        navigationItem.leftBarButtonItem = settingsBarButtonItem
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReservation))
        let editBarButtonItem = UIBarButtonItem(title: "Edit List Order",style: .done, target: self, action: #selector(editReservationsList))
        
        navigationItem.rightBarButtonItems = [addBarButtonItem, editBarButtonItem]

        let nib = UINib(nibName: "ReservationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReservationCell")
    }
    
    @objc func addReservation() {
        let addReservationViewController = AddReservationViewController()
        let navController = UINavigationController(rootViewController: addReservationViewController)
        modalPresentationStyle = .formSheet
        addReservationViewController.delegate = self
        present(navController, animated: true, completion: nil)
    }

    @objc func settings() {
        let settingsViewController = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsViewController)
        modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }
    
    @objc func editReservationsList() {
        tableView.isEditing = tableView.isEditing ? false : true
        let rightBarButtonItems = navigationItem.rightBarButtonItems
        //Not hacky at all
        if tableView.isEditing {
            let editButtonArray = rightBarButtonItems?.filter{ $0.title == "Edit List Order" }
            guard let editButton = editButtonArray?.first else { return }
            editButton.title = "Finish Editing"
        } else {
            let editButtonArray = rightBarButtonItems?.filter{ $0.title == "Finish Editing" }
            guard let editButton = editButtonArray?.first else { return }
            editButton.title = "Edit List Order"
        }
    }
}
