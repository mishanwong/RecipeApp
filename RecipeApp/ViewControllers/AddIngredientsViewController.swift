//
//  AddEntriesViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/9/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

protocol PassData {
    func passDataBack(data: [String])
}

class AddIngredientsViewController: UIViewController, UITextFieldDelegate {
        
    var ingredients = [String]()
    var delegate:PassData?
    
    @IBOutlet weak var addIngredientsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Ingredients"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addIngredientsTextField.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return addIngredientsTextField.resignFirstResponder()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        //Send it back to Add Recipe View Controller
        delegate?.passDataBack(data: ingredients)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
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
        
        //Clear out the text field
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addIngredientsCell, for: indexPath)
        
        //Configure cell
        cell.textLabel?.text = ingredients[indexPath.row]
        
        return cell
    }
    
    
    
}
