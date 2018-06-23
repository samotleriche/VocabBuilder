//
//  ViewController.swift
//  VocabBuilder
//
//  Created by Tomas Leriche on 6/7/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import UIKit
import RealmSwift

class VocabListViewController: UITableViewController, UISearchBarDelegate {
    
    var todoWords: Results<Word>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
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
        return todoWords?.count ?? 1
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        
        if let word = todoWords?[indexPath.row] {
        
            cell.textLabel?.text = word.title
        
            cell.accessoryType = word.learned ? .checkmark : .none
        }else{
            cell.textLabel?.text = "no items added"
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        if let word = todoWords?[indexPath.row] {
            do{
                try realm.write {
                    word.learned = !word.learned
                    //realm.delete(word)
                }
            }catch{
                print(error)
            }
        }
        
        tableView.reloadData()
        
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func RemoveSelection(_ sender: UIBarButtonItem) {
        
        
    }
    
    @IBAction func addWordPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Word", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Word", style: .default) { (action)
            in
            //what happens when add item button is clicked in UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newWord = Word()
                        newWord.title = textField.text!
                        newWord.dateAdded = Date()
                        currentCategory.words.append(newWord)
                    }
                }catch {
                    print("error saving: \(error)")
                }
            }
            self.tableView.reloadData()
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
    
    
    func loadItems() {

        todoWords = selectedCategory?.words.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoWords = todoWords?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateAdded", ascending: true)

        tableView.reloadData()
        
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

