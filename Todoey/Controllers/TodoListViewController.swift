//
//  ViewController.swift
//  Todoey
//
//  Created by Cody on 2019/3/4.
//  Copyright © 2019 cody. All rights reserved.
//
import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    //let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
        
        //saving cell's data into location machine by NSCoder
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colour else{fatalError()}
        
        updateNavBar(withHexCode: colourHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: -nav bar setup method
    func updateNavBar (withHexCode colourHexColour: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("navigationController does not exist!")}
        guard let navBarColour = UIColor(hexString: colourHexColour) else {fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    //MARK: - TableView Datasource Methods
    //1. how many cells?(number)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    //2. what should the cell put data into it?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        
        //set cell txt label
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        
        //ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        
        //cell.accessoryType = item.done == true ? .checkmark : .none
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            
            cell.textLabel?.text = "No Item Added"
            
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    //1. this is the function to tell where the finger click.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                item.done = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        //ui alert
        //1.showing message (top message)
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //2.alert action (button)
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }catch{
                    print("Error saving items \(error) ")
                }
                
            }
            
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
    
    //MARK: - Model Manupulation Methods

    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let itemForDeletion = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting cell \(error)")
            }
            
        }
        
    }


}

//MARK: - search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //disapear the cursor in searchBar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }


}

