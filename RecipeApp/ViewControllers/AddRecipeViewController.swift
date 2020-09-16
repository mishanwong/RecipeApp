//
//  AddRecipeViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/1/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddRecipeViewController: UIViewController {
    
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
    
    @IBAction func addDishNameButtonTapped(_ sender: Any) {
        
        //Consider removing this and add in Recipes Model
                
                //Tapping this button will create a new document in the recipes collection in Firestore
                
        //        let db = Firestore.firestore()
        //
        //        let newRecipe = db.collection("recipes").document()
        //
        //        newRecipe.setData(["recipeId":newRecipe.documentID, "dishName":dishNameTextField.text!])
    }
    
    @IBAction func photoTapped(_ sender: Any) {
        
        //Create the action sheet
        let actionSheet = UIAlertController(title: "Add a Photo", message: "Select a source:", preferredStyle: .actionSheet)
        
        //Only add the Camera button if it is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //Create and add the Camera button
            let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
                
                //Display the UIImagePickerController set to camera mode
                self.showImagePickerController(mode: .camera)
                
            }
            actionSheet.addAction(cameraButton)
            
        }
        
        //Only add the Photo Library button if it is available
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //Create and add the Photo Library button
            let libraryButton = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                
                //Display the UIImagePickerController set to library mode
                self.showImagePickerController(mode: .photoLibrary)
                
            }
            actionSheet.addAction(libraryButton)
        }
        
        //Create and add the Cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelButton)
        
        //Display the action sheet
        present(actionSheet, animated: true)
        
    }
    
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
                               "instructions": instructions])
            
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
        
        
    }
    
    
    func showImagePickerController(mode: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = mode
        imagePicker.delegate = self
        
        //Present the image picker
        present(imagePicker, animated: true)
    }
}



// MARK: - Image picker protocol functions
extension AddRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Get a reference to the selected photo
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //Check that the selected image isn't nil
        if let selectedImage = selectedImage {
            
            //Get a reference to the UploadPhotoButton
            let uploadPhotoButton = UploadPhotoButton()
            
            //Upload it
            uploadPhotoButton.savePhoto(image: selectedImage)
        }
        
        //Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
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
            
            
//            let ingredientsIndexPath = IndexPath(row: indexPath.row, section: 0)
//            let seasoningsIndexPath = IndexPath(row: indexPath.row, section: 1)
//            let instructionsIndexPath = IndexPath(row: indexPath.row, section: 2)
            
            //if indexPath.section == 0 {
//                ingredients.remove(at: ingredientsIndexPath.row)
//                tableView.beginUpdates()
//                tableView.deleteRows(at: [ingredientsIndexPath], with: .automatic)
//                tableView.endUpdates()
        //}
            
//            if indexPath.section == 1 {
//                ingredients.remove(at: seasoningsIndexPath.row)
//                tableView.beginUpdates()
//                tableView.deleteRows(at: [seasoningsIndexPath], with: .automatic)
//                tableView.endUpdates()
//
//            }
//
//            if indexPath.section == 2 {
//                ingredients.remove(at: instructionsIndexPath.row)
//                tableView.beginUpdates()
//                tableView.deleteRows(at: [instructionsIndexPath], with: .automatic)
//                tableView.endUpdates()
//
//            }
            
            
            
            
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

