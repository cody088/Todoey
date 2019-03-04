//
//  ViewController.swift
//  Todoey
//
//  Created by Cody on 2019/3/4.
//  Copyright © 2019 cody. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [item]()
    
    //saving cell's data into location machine by NSCoder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
       
       
        
//        let newItem = item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
//
        //reload actual device data into screen
        //        if let items = defaults.array(forKey: "TodoListArray") as? [item]
        //        {
        //            itemArray = items
        //        }
        loadItems()
        
    }
    
    //MARK - TableView Datasource Methods
    //1. how many cells?(number)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //2. what should the cell put data into it?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //set cell txt label
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        
        //cell.accessoryType = item.done == true ? .checkmark : .none
        cell.accessoryType = item.done ? .checkmark : .none
        
//(same function as above)
// if item.done == true {
// cell.accessoryType = .checkmark
// }else{
// cell.accessoryType = .none
// }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    //1. this is the function to tell where the finger click.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //add checkmark to cell
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //add & remove checkmark to cell (using if condition)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
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
            let newItem = item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //save data in actual device
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
            
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
    
    //MARK - Model Manupulation Methods
    func saveItems() {
        //using NSCoder to save item data on device
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array,\(error)")
        }
        
        //reloadData into Table
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        //decoder data from device
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([item].self, from:data)
            }
            catch{
                print("Error decoding item array, \(error)")
            }
            
        }
    }

}

