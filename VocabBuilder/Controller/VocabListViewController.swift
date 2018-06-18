//
//  ViewController.swift
//  VocabBuilder
//
//  Created by Tomas Leriche on 6/7/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import UIKit

class VocabListViewController: UITableViewController {
    
    var itemArray = [Word]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Words.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath!)
        
        loadItems()
      
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
        
        cell.textLabel?.text = word.word
        
        cell.accessoryType = word.learned ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].learned = !itemArray[indexPath.row].learned
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addWordPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Word", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Word", style: .default) { (action) in
            //what happens when add item button is clicked in UIAlert
            print("success!")
            print(textField.text!)
            
            
            
            if textField.text == nil {
                //debug stuff
                print("nothing entered")
            }else{
                
                let newWord = Word()
                newWord.word = textField.text!
                
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("error: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Word].self, from: data)
            }catch{
                print("error: \(error)")
            }
        }
    }
    
}

