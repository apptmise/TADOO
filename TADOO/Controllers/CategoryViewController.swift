//
//  CategoryViewController.swift
//  TADOO
//
//  Created by Faiq Khan on 06/12/2018.
//  Copyright © 2018 apptmise. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>?
    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //CORE                                                           
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    
   
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) // Re-Use of old table cells as you scroll
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TADOOListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //initilise it to an empty textfield
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //when add item is pressed.
            
            let newCategory = Category() //REALM way
//            let newCategory = Category(context: self.context) - CORE DATA VERSION
            newCategory.name = textField.text!
//            self.categoryArray.append(newCategory)
            
            //dont need to append like core data, categories-Results global variable auto updates
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
        
    }
    
    //REALM SAVE
    func save(category: Category) {
        do {
            //            try context.save() - OLD CORE DATA WAY
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving content \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    // REALM FETCH
    func loadCategories() {
        categories = realm.objects(Category.self)
    }


}
