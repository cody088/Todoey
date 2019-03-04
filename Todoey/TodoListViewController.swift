//
//  ViewController.swift
//  Todoey
//
//  Created by Cody on 2019/3/4.
//  Copyright © 2019 cody. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike","Buy Eggos","Destory Demogorgon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    //MARK - TableView Datasource Methods
    //1. how many cells?(number)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //2. what should the cell put data into it?(location)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //set cell txt label
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    //1. this is the function to tell where the finger click.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //add checkmark to cell
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        //add & remove checkmark to cell (using if condition)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        //making the gray colour fade away in the cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //ui alert
        //1.showing message (top message)
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //2.alert action (button)
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            self.itemArray.append(textField.text!)
            
            //reloadData into Table
            self.tableView.reloadData()
            
        }
        //2.5 insert a text field inside alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        
        }
        //3.add action
        alert.addAction(action)
        
        //4.after alert action complete then close the alert
        present(alert, animated: true, completion: nil)
        
    }
    

}

