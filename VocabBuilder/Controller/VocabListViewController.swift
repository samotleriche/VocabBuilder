//
//  ViewController.swift
//  VocabBuilder
//
//  Created by Tomas Leriche on 6/7/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class VocabListViewController: SwipeViewController, UISearchBarDelegate {
    
    var todoWords: Results<Word>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let hexcolor = selectedCategory?.color else { fatalError() }
        
        updateNavBar(withHexCode: hexcolor)
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        updateNavBar(withHexCode: "2A43FF")
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - NAV BAR SETUP METHODS
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("nav controller doesnt exist")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf((navBarColor), returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoWords?.count ?? 1
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let word = todoWords?[indexPath.row] {
        
            cell.textLabel?.text = word.title
        
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(todoWords!.count)){
                cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
           
            
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let word = todoWords?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(word)
                }
            }catch{
                print(error)
            }
            
        }
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

