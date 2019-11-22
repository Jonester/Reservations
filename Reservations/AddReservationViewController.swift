//
//  AddReservationViewController.swift
//  Reservations
//
//  Created by Chris Jones on 2019-11-20.
//  Copyright © 2019 Chris Jones. All rights reserved.
//

import UIKit
import CoreData


protocol AddReservationDelegate: class {
    func refreshTableView()
}

class AddReservationViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var partySizeTextField: UITextField!

    weak var delegate: AddReservationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredContentSize = CGSize(width: view.frame.size.width, height: 300)

        title = NSLocalizedString("Customer Info", comment: "")
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReservation))
        navigationItem.rightBarButtonItem = addBarButtonItem

        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    @objc func saveReservation() {
        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let context = container.viewContext

        guard let name = nameTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            let partySizeString = partySizeTextField.text,
            let partySize = Int16(partySizeString) else { return }
        let _ = Reservation.reservation(name: name, phoneNumber: phoneNumber, partySize: partySize, context: context)
        do {
            try context.save()
        } catch {
            print("Oops")
        }
        dismiss(animated: true) {
            self.delegate?.refreshTableView()
        }
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}

