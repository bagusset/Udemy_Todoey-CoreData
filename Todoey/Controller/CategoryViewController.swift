//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bagus setiawan on 13/09/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryItem = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            
            self.categoryItem.append(newItem)
            
            //self.saveItem()
            
            //self.defaults.set(self.array, forKey: "toDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "Create New Category"
            textField = alertTexField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory(){
        do{
            try context.save()
        }catch{
            print("Eror saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryItem = try context.fetch(request)
        } catch{
            print("Eror fetching data from category\(error)")
        }
        
        tableView.reloadData()
    }
    
   
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let category = categoryItem[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let destinationVC = segue.destination as! ViewController
           
           if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryItem[indexPath.row]
           }
       }
   
}
