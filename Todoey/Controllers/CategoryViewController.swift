//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Cody on 2019/3/10.
//  Copyright © 2019 cody. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController  {
 
    
    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
   
        tableView.separatorStyle = .none
        
    }

    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newC = Category()
            newC.name = textField.text!
            newC.colour = UIColor.randomFlat.hexValue()
            self.save(category: newC)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a New Category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added yet"
        
        let colour = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
        cell.backgroundColor = colour
        cell.textLabel!.textColor = ContrastColorOf(colour!, returnFlat: true)
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToitems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }

    }
    
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = categories?[indexPath.row] {
            do{
                try realm.write {
                realm.delete(categoryForDeletion)
                }
        }catch{
                print("Error deleting cell \(error)")
            }
        
        }
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
}

