//
//  ViewController.swift
//  To Do
//
//  Created by Laura van der Stee on 14-05-17.
//  Copyright © 2017 Laura van der Stee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskArray : [Taskclass] = []
    
    /*
    var context: NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController = {
    let tasksFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
    let dateSortDescriptor = NSSortDescriptor(key: "task.date", ascending: true)
    tasksFetchRequest.sortDescriptor = [dateSortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: tasksFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: "task.date",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // elke keer als het scherm opnieuw laad, doet de tabel de volgende taken
        getTasks()
        // het haalt alle taak entities op van de core data en stopt het in de array (zie onderaan)
        tableView.reloadData()
        // het laad de data opnieuw, zodat je dit ook daadwerkelijk in het scherm ziet (in de array stoppen is niet data herladen..)
    }
    
    @IBAction func addTapped(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let taskindex = taskArray[indexPath.row]
        // definieer een constante: taskindex is de taak die in de taskArray op dat plekje staat van de rij waar je je in bevind
        let formatter = DateFormatter ()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.none
        let dateString = formatter.string(from: taskindex.date! as Date)
        if taskindex.important {
            cell.textLabel?.text = "❗️\(taskindex.name!), \(dateString)"
        } else{
            cell.textLabel?.text = "\(taskindex.name!), \(dateString)"
        }
        // zo bepalen wat hij moet laten zien. als de taak important is moet hij ook uitroep tekens laten zien, anders alleen de tekst
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Done")   { (_ rowAction: UITableViewRowAction, _ indexPath: IndexPath) in
            let task = self.taskArray[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.getTasks()
            self.tableView.reloadData()
        }
        let editAction = UITableViewRowAction(style: .default, title: "Edit")   { (_rowAction: UITableViewRowAction, _indexPath: IndexPath) in
            let task = self.taskArray[indexPath.row]
            self.performSegue(withIdentifier: "addTaskSegue", sender: task)
        }
        deleteAction.backgroundColor = UIColor.init(colorLiteralRed: (127/255), green: (219/255), blue: (193/255), alpha: 1)
        editAction.backgroundColor = UIColor.init(colorLiteralRed: (255/255), green: (163/255), blue: (69/255), alpha: 1)
        return [deleteAction, editAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.taskArray[indexPath.row]
        self.performSegue(withIdentifier: "addTaskSegue", sender: task)
    }
    
    func getTasks() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            taskArray = try context.fetch(Taskclass.fetchRequest()) as! [Taskclass]
            print(taskArray)
        } catch {
            print("oeps, we have an error!!")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTaskSegue" {
            let nextVC = segue.destination as! settingsTableViewController
            nextVC.task = sender as? Taskclass
        }
    }

}
