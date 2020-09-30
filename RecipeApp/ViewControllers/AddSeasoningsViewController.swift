//
//  AddSeasoningsViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/9/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

protocol PassData2 {
    func passDataBack2(data: [String])
}

class AddSeasoningsViewController: UIViewController, UITextFieldDelegate {
    
    var seasonings = [String]()
    var delegate:PassData2?
    
    @IBOutlet weak var addSeasoningsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Seasonings"
        
        tableView.delegate = self
        tableView.dataSource = self
        addSeasoningsTextField.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return addSeasoningsTextField.resignFirstResponder()
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        
        let trimmed = addSeasoningsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed != "" {
            insertNewRow()
        }
        
    }
    
    func insertNewRow() {
        
        seasonings.append(addSeasoningsTextField.text!)
        
        let indexPath = IndexPath(row: seasonings.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        addSeasoningsTextField.text = ""
        
        view.endEditing(true)
        
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        delegate?.passDataBack2(data: seasonings)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddSeasoningsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasonings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addSeasoningsCell, for: indexPath)
        
        cell.textLabel?.text = seasonings[indexPath.row]
        
        return cell
    
    }
    
    
    
}
