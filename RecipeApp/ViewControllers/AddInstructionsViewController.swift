//
//  AddInstructionsViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/9/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

protocol PassData3 {
    func passDataBack3(data: [String])
}

class AddInstructionsViewController: UIViewController {
    
    var instructions = [String]()
    var delegate:PassData3?
    
    
    @IBOutlet weak var addInstructionsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Instructions"
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    

    @IBAction func addButtonTapped(_ sender: Any) {
        
        let trimmed = addInstructionsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed != "" {
            insertNewRow()
        }
    }
    
    func insertNewRow() {
        
        instructions.append(addInstructionsTextField.text!)
        
        let indexPath = IndexPath(row: instructions.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        //Clear out the text field
        addInstructionsTextField.text = ""
        
        //Dismiss the keyboard
        view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        //Send it back to Add Recipe View Controller
        delegate?.passDataBack3(data: instructions)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension AddInstructionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addInstructionsCell, for: indexPath)
        
        //Configure cell
        cell.textLabel?.text = instructions[indexPath.row]
        
        return cell
    }
    
    
    
}
