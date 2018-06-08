//
//  ViewController.swift
//  VocabBuilder
//
//  Created by Tomas Leriche on 6/7/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import UIKit

class VocabListViewController: UITableViewController {
    
    var itemArray = ["Word1", "Word2", "Word3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
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
                self.itemArray.append(textField.text!)
                //debugg stuff
                print(self.itemArray)
                self.tableView.reloadData()
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
    
}

