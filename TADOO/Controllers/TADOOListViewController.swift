//
//  ViewController.swift
//  TADOO
//
//  Created by Faiq Khan on 02/12/2018.
//  Copyright © 2018 apptmise. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TADOOListViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
//
    }

    //----------------------------------------------------------------------------------------------
    
    //MARK: - Tableview Datasource
    // (1)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
 
    // (2)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) // Re-Use of old table cells as you scroll
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        }else {
            cell.textLabel?.text = "No Item Found"
        }
                                         // link to data model
        
        //TERNARY OPERATOR:
        //[value] = [condition] ? [valueIfTrue] : [valueIfFalse]             // This is shown below to replace the if statement below it
        
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
    
    //MARK: - TableView Delegate Methods
    // (1)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            }catch {
                print("Error saving done status, \(error)")
            }
            
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //----------------------------------------------------------------------------------------------

    //MARK: - Add New Items
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //initilise it to an empty textfield
        
        let alert = UIAlertController(title: "Add New TADOO Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //when add item is pressed.
            
            if let currentCategory = self.selectedCategory { //if not nil
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving new items, \(error)")
                }
            } //end of if statement
            self.tableView.reloadData()
        } //end of closure
        
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    //----------------------------------------------------------------------------------------------
    
    //MARK: - Model Manupulation Methods**
    
    //REALM load:
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    //REALM SAVE
//    func save(itemForRealm: Item) {
//
//        do {
//            try realm.write {
//                realm.add(itemForRealm)
//            }
//        } catch {
//            print("Error saving content \(error)")
//        }
//        tableView.reloadData()
//    }
    
    
    
//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving content \(error)")
//        }
//        tableView.reloadData()
//    }
//
    

    
//    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { //with is for external param usage-see search bar - request is internal - see below
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
    
} //End of Class




//MARK: - SEARCHBAR Function via Extension use of same original controller
extension TADOOListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //RETRIEVE DATA
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending:  true)
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //cd -make sure case and symbols above any letters are excluded in the search. %@ is what we search from searchBar.text. CONTAINS is a NSPedicate command which checks if any pieces of data contain our searchBar.text we entered. eg the first word of the something. still brings up the results.
//        //SORT OUT RESULTS
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        //LOAD SEARCHED ITEMS
//        loadItems(with: request, predicate: predicate)
//
        tableView.reloadData() // refresh table view to bring up the data∫
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
             // take searchBar off active state in controller, point user back to main screen
        }
    }
    
    
}
