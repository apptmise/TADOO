//
//  CategoryViewController.swift
//  TADOO
//
//  Created by Faiq Khan on 06/12/2018.
//  Copyright © 2018 apptmise. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //CORE                                                           
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
   
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) // Re-Use of old table cells as you scroll
        
        let cat = categoryArray[indexPath.row]                                  // put into category constant to shorten words
        cell.textLabel?.text = cat.name                              // link to data model
        return cell                                                                              // returns the cell to the table
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TADOOListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //initilise it to an empty textfield
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //when add item is pressed.
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            //            newItem.done = false
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
        
    }
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error saving content \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()) { //with is for external param usage-see search bar - request is internal - see below
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        
        tableView.reloadData()
        
    }

}
