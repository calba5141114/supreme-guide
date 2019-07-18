//
//  ViewController.swift
//  Todo_list
//
//  Created by Carlos Alba on 7/17/19.
//  Copyright © 2019 us.carlosalba. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckBox: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTodoItems()
    }
    
    func getTodoItems(){
        // Get the todo items from Core Data
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer
            .viewContext{
            do {
                // set them to the class property
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
            }
            catch {
            }
        }
        // update the table
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if textField.stringValue != "" {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer
                .viewContext{
                let todoItem = ToDoItem(context: context)
                todoItem.name = textField.stringValue
                
                if importantCheckBox.state.rawValue == 0 {
                    // Not Important
                    todoItem.important = false
                }
                else {
                    // important
                    todoItem.important = true
                }
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckBox.state = .off
                
                getTodoItems()
                
            }
        }
    }
    
    // deleting the selected row
    @IBAction func deleteClicked(_ sender: Any) {
        let toDoItem = toDoItems[tableView.selectedRow]
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer
            .viewContext{
            context.delete(toDoItem)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            // refresh todos
            getTodoItems()
            // hide revealed delete button
            deleteButton.isHidden = true
        }
        
    }
    
    // MARK: - TableView stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let toDoItem = toDoItems[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue:"importantColumn") {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView {
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                }
                else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        }
        else {
            // todo column
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoItems"), owner: self) as? NSTableCellView {
                cell.textField?.stringValue = toDoItem.name!
                return cell
            }
        }
        return nil
    }
    
    // hide and show delete button
    func tableViewSelectionDidChange(_ notification: Notification) {
        // shows button
        deleteButton.isHidden = false
    }
    
    
}


