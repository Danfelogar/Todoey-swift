//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //.appending(path: "Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //set data safe in divece
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath )
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        //ternary operator
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //first remove the context
        //context.delete(itemArray[indexPath.row])
        //second delete of local array
        //itemArray.remove(at: indexPath.row)
        
        // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()        
        //for flashing cells
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //local variable
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            //Context of Data Model with singelton patern
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory =  self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        //commat for show alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        //save updated itemArry

        do{
           try self.context.save()
        } catch{
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,additionalPredicate])
        } else{
            request.predicate = categorypredicate
        }

        do {
          itemArray = try context.fetch(request)
        } catch {
            print("Error fetching datafrom context \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}

//MARK: - SearchBar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:  NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // use dispatchqueue for past request un second level
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
