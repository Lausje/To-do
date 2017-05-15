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
    var datePickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerChanged()
        print(datePickerHidden)
        print(task as Any)
        nameTextField.text = task?.name
        importantSwitch.isOn = (task?.important)!
        let formatter = DateFormatter ()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.none
        let dateString = formatter.string(from: task?.date as! Date)
        dateDetailLabel.text = dateString
        datePicker.date = (task?.date)! as Date
    }

    func datePickerChanged () {
        dateDetailLabel.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
    }
    
    @IBAction func datePickerValue(_ sender: UIDatePicker) {
        datePickerChanged()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        print(section, row)
        if indexPath.section == 1 && indexPath.row == 1 {
            toggleDatepicker()
            print(datePickerHidden)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 1 && indexPath.row == 2 {
            return 0
        }
        else if datePickerHidden == false && indexPath.section == 1 && indexPath.row == 2 {
            return 218
        }
        else {
            return 44
        }
    }

    
    func toggleDatepicker() {
        if datePickerHidden == false {
            datePickerHidden = true
        } else {
            datePickerHidden = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if task != nil {
            task?.name = nameTextField.text
            task?.important = importantSwitch.isOn
            task?.date = datePicker.date as NSDate
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let task = Taskclass(context: context)
            task.name = nameTextField.text!
            task.important = importantSwitch.isOn
            task.date = datePicker.date as NSDate
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
      
        navigationController!.popViewController(animated: true)
    }
    
}
