//
//  settingsTableViewController.swift
//  To Do
//
//  Created by Laura van der Stee on 14-05-17.
//  Copyright © 2017 Laura van der Stee. All rights reserved.
//

import UIKit

class settingsTableViewController: UITableViewController {
    


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var dateDetailLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addSaveButton: UIBarButtonItem!

    
    var task : Taskclass? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerChanged()
    }

    func datePickerChanged () {
        dateDetailLabel.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
    }
    
    @IBAction func datePickerValue(_ sender: UIDatePicker) {
        datePickerChanged()
    }
    
    
    
    @IBAction func saveTapped(_ sender: Any) {
        if task != nil {
            task?.name = nameTextField.text
            task?.important = importantSwitch.isOn
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let task = Taskclass(context: context)
            task.name = nameTextField.text!
            task.important = importantSwitch.isOn
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
}
