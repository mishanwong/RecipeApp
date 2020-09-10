//
//  AddEntriesViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/9/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

class AddIngredientsViewController: UIViewController {
    
    var ingredients = [String]()
    
    
    @IBOutlet weak var addIngredientsTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Ingredients"
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let trimmed = addIngredientsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed != "" {
            
            insertNewRow()
        }
        
    }
    
    func insertNewRow() {
        
        //Prototyping for Ingredients first
        ingredients.append(addIngredientsTextField.text!)
        
        let indexPath = IndexPath(row: ingredients.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        //Clear out the typing text field
        addIngredientsTextField.text = ""
        
        //Dismiss the keyboard
        view.endEditing(true)

    }
    
    
}

extension AddIngredientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddIngredientsCell", for: indexPath)
        
        //TODO: Configure cell
        cell.textLabel?.text = ingredients[indexPath.row]
        
        return cell
    }
    
    
    
}
