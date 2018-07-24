//
//  CategoryViewController.swift
//  VocabBuilder
//
//  Created by Tomas Leriche on 6/21/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {
    
    let realm = try! Realm()

    var categoryArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCategories()
        
        tableView.separatorStyle = .none
        
        
        if let navBar = navigationController?.navigationBar {
         
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : FlatWhite()]
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
        if let category = categoryArray?[indexPath.row] {
        
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else { fatalError() }
            
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            if categoryArray?[indexPath.row].learned == true {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToWords", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! VocabListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action)
            in
            //what happens when add item button is clicked in UIAlert
           
            if textField.text == nil {
                //debug stuff
                print("nothing entered")
            }else{
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.learned = false
                newCategory.color = UIColor.randomFlat.hexValue()
                
                self.save(category: newCategory)
            }
        }
        alert.addTextField { (alertTextField)
            in
            alertTextField.placeholder = "Add New Category"
            //debug stuff - this line below prints empty.
            //print(alertTextField.text!)
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Dataset
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            }catch{
                print(error)
            }
            //tableView.reloadData()
        }
    }
}



