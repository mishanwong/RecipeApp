//
//  AddRecipeViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/1/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit
import Firebase

class AddRecipeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var recipe:Recipe?
    
    var ingredients = [String]()
    var seasonings = [String]()
    var instructions = [String]()
    
    var sections = [Section(name: "Ingredients", items: []),
                    Section(name: "Seasonings", items: []),
                    Section(name: "Instructions", items: [])]
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Recipe"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.dishNameTextField.delegate = self
                
    }
    
    // Hide keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Hide keyboard on return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return dishNameTextField.resignFirstResponder()
    }
    
    // MARK: - Prepare for storyboard segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.addRecipeToAddIngredients {
            
            let addIngredientsVC = segue.destination as! AddIngredientsViewController
            addIngredientsVC.ingredients = ingredients
            addIngredientsVC.delegate = self
        }
        
        if segue.identifier == Constants.addRecipeToAddSeasonings {
            
            let addSeasoningsVC = segue.destination as! AddSeasoningsViewController
            addSeasoningsVC.seasonings = seasonings
            addSeasoningsVC.delegate = self
        }
        
        if segue.identifier == Constants.addRecipeToAddInstructions {
            
            let addInstructionsVC = segue.destination as! AddInstructionsViewController
            addInstructionsVC.instructions = instructions
            addInstructionsVC.delegate = self
        }
    }
    
    // MARK: - IB Action functions
    
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        let checkFields = areAllFieldsEntered()
        if checkFields {
            //Write to database
            //Get a reference to the database
            let db = Firestore.firestore()
            
            //Create a new document
            let newRecipe = db.collection("recipes").document()
            
            //Save data to database
            newRecipe.setData(["recipeId":newRecipe.documentID,
                               "dishName": dishNameTextField.text ?? "",
                               "ingredients": ingredients,
                               "seasonings": seasonings,
                               "instructions": instructions,
                              "urlString":"tbd"])
            
            //Return to Add Recipe View Controller
            navigationController?.popViewController(animated: true)
            
        } // End if checkFields()
        
        else {
            return
        }
    
    } // End saveTapped
    
    func areAllFieldsEntered() -> Bool {
        //This function checks if all fields (Dish name, ingredients, seasonings and instructions) are filled.
        //Return true if all fields are filled
        
        if dishNameTextField.text!.isEmpty || ingredients.isEmpty || seasonings.isEmpty || instructions.isEmpty {
            showIncompleteAlert()
            return false
        }
        else {
            return true
        }
        
        
    }
    
    func showIncompleteAlert() {
        
        let alert = UIAlertController(title: "Incomplete Form", message: "Please fill out all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        
    } // End func showIncompleteAlert

}

// MARK: - UI Table View protocol functions
extension AddRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    } // End numberOfSections
    
    //Setting the header for the 3 sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    } // End titleForHeaderInSection
    
    //Setting the number of rows in the table view
    //TODO: - Refactor this code later
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var items = sections[section].items
        
        if section == 0 {
            items = ingredients
        }
        
        if section == 1 {
            items = seasonings
        }
        
        if section == 2 {
            items = instructions
        }
        return items!.count
        
    } // End numberOfRowInSection
    
    //Setting the cell for each table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell")!
        
        var items = sections[indexPath.section].items
        
        if indexPath.section == 0 {
            items = ingredients
        }
        
        if indexPath.section == 1 {
            items = seasonings
        }
        
        if indexPath.section == 2 {
            items = instructions
        }
        print(items!)
        
        if items!.count > 0 {
            let item = items![indexPath.row]
            cell.textLabel?.text = item
        }
        return cell
       
    } // End func
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                ingredients.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                
            }
            if indexPath.section == 1 {
                seasonings.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                
            }
            if indexPath.section == 2 {
                instructions.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                
            }
        } // End if editingStyle
    } // End commit editingStyle
    
     
} // End extension


//MARK: - PassData Protocol function
extension AddRecipeViewController: PassData {
    
    func passDataBack(data: [String]) {
        
        //Append the ingredients array from previous VC to ingredients array in current VC
        ingredients = ingredients + data
        tableView.reloadData()
    }
}

extension AddRecipeViewController: PassData2 {
    
    func passDataBack2(data: [String]) {
        
        seasonings = seasonings + data
        tableView.reloadData()
    }
    
}

extension AddRecipeViewController: PassData3 {
    
    func passDataBack3(data: [String]) {
        instructions = instructions + data
        tableView.reloadData()
    }
    
    
}


