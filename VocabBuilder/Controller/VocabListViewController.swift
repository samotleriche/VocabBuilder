//
//  ViewController.swift
//  VocabBuilder
//
//  Created by Tomas Leriche on 6/7/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import UIKit
import CoreData

class VocabListViewController: UITableViewController, UISearchBarDelegate {
    
    var itemArray = [Word]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        
        let word = itemArray[indexPath.row]
        
        cell.textLabel?.text = word.wordName
        
        cell.accessoryType = word.learned ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        
        itemArray[indexPath.row].learned = !itemArray[indexPath.row].learned
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func RemoveSelection(_ sender: UIBarButtonItem) {
        
        
        for (x, y) in itemArray.enumerated() {
            
            //print(x, "and ", y)
            if y.learned == true {
                
                print(x, "needs deleting")
                context.delete(itemArray[x])
                itemArray.remove(at: x)
                let request : NSFetchRequest<Word> = Word.fetchRequest()
                loadItems(with: request)
                //saveItems()
                
//                if let indexPath = tableView.indexPathForSelectedRow {
//                    destinationVC.selectedCategory = categoryArray[indexPath.row]
//                }
            }
            
        }
        
        
//        context.delete(itemArray[0])
//        itemArray.remove(at: 0)
        
        saveItems()
        
        
    }
    
    @IBAction func addWordPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Word", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Word", style: .default) { (action)
            in
            //what happens when add item button is clicked in UIAlert
            print("add button pressed!")
            print(textField.text!)
            
            
            
            if textField.text == nil {
                //debug stuff
                print("nothing entered")
            }else{
                let newWord = Word(context: self.context)
                newWord.wordName = textField.text!
                newWord.learned = false
                newWord.parentDifficulty = self.selectedCategory
                
                self.itemArray.append(newWord)
                
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Word"
            //debug stuff - this line below prints empty.
            //print(alertTextField.text!)
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        }catch{
            print("error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Word> = Word.fetchRequest(), predicate: NSPredicate? = nil) {
       
        let categoryPredicate = NSPredicate(format: "parentDifficulty.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error fetching: \(error)")
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Word> = Word.fetchRequest()
        
        //print(searchBar.text!)
        
        let predicate = NSPredicate(format: "wordName CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "wordName", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

