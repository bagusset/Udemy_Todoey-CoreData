//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var todoeyTableView: UITableView!
    
    
    var array = [Item]()
    //let defaults = UserDefaults.standard
    
    var selectedCategory : Category? {
        didSet{
            loadItem()
        }
    }
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    
    @IBAction func addNewItemBtn(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.status = false
            newItem.parentCategory = self.selectedCategory
            
            self.array.append(newItem)
            
            self.saveItem()
            
            //self.defaults.set(self.array, forKey: "toDoListArray")
            
            self.todoeyTableView.reloadData()
            
        }
        
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "Create New Item"
            textField = alertTexField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem(){
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.todoeyTableView.reloadData()
        
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let aditionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates : [categoryPredicate, aditionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            array = try context.fetch(request)
        } catch {
            print("Eror fetching data from Item \(error)")
        }
        
        todoeyTableView?.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoeyTableViewCell", for: indexPath) as! todoeyTableViewCell
        let item = array[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.status == true ? .checkmark: .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveItem()
        
//        array[indexPath.row].setValue("completed", forKey: "title")
//                context.delete(array[indexPath.row])
//                 array.remove(at: indexPath.row)
        
        array[indexPath.row].status = !array[indexPath.row].status
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request, predicate: predicate)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}


