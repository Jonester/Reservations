//
//  SettingsViewController.swift
//  Reservations
//
//  Created by Chris Jones on 2019-11-21.
//  Copyright © 2019 Chris Jones. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var messageTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Settings", comment: "")
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationItem.rightBarButtonItem = addBarButtonItem

        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveSettings() {
        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let context = container.viewContext
        guard let message = messageTextView.text else { return }
        let _ = Settings.settings(message: message, context: context)
        do {
            try context.save()
        } catch {
            print("Oops")
        }
        dismiss(animated: true, completion: nil)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
