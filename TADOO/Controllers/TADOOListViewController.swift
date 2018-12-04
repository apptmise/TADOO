//
//  ViewController.swift
//  TADOO
//
//  Created by Faiq Khan on 02/12/2018.
//  Copyright © 2018 apptmise. All rights reserved.
//

import UIKit

class TADOOListViewController: UITableViewController {
    
    var itemArray = [Item]()                        // link to data model - item.swift
    
    let defaults = UserDefaults.standard            // connecting user defaults in a constant - retrieve and run actions through new constant : defaults

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Find Fike"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Find Cammy"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Loz"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
//        example used instead of an array. testing purpose for the data model
    }

    //----------------------------------------------------------------------------------------------
    
    //MARK - Tableview Datasource
    // (1)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
 
    // (2)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) // Re-Use of old table cells as you scroll
        
        let item = itemArray[indexPath.row]                                  // put into item constant to shorten words
        cell.textLabel?.text = item.title                                    // link to data model
        
        //TERNARY OPERATOR:
        //[value] = [condition] ? [valueIfTrue] : [valueIfFalse]             // This is shown below to replace the if statement below it
        cell.accessoryType = item.done == true ? .checkmark : .none
        //this can further be shortened by:
        //cell.accessoryType = item.done ? .checkmark : .none

//        if item.done == true {                                               // Toggle for checkmark status on each cell
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        return cell                                                                              // returns the cell to the table
    }
    
    //----------------------------------------------------------------------------------------------
    
    //MARK - TableView Delegate Methods
    // (1)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done                      //this single line replaces the if statement belowe
        //it essentially toggles the opposite of the itemArray.done property regardless of whether it is true or false
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData() //very important as it calls all tableview methods again. specifically to re-run cellforRow, to get the checkmark to refresh
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //----------------------------------------------------------------------------------------------

    //MARK - Add New Items
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //initilise it to an empty textfield
        
        let alert = UIAlertController(title: "Add New TADOO Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //when add item is pressed.
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)

            self.defaults.set(self.itemArray, forKey: "TodoListArray")//save data to plist
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    //----------------------------------------------------------------------------------------------
    
} //End of Class

