//
//  AddRecipeViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/1/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit
import Firebase

class AddRecipeViewController: UIViewController {
    
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var addSeasoningsTextField: UITextField!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var seasoningsTableView: UITableView!
    @IBOutlet weak var instructionsTableView: UITableView!
    
    var recipe:Recipe?
    
    var ingredients = [String]()
    var seasonings = [String]()
    var instructions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Recipe"
        seasoningsTableView.tableFooterView = UIView(frame: CGRect.zero)
        seasoningsTableView.delegate = self
        seasoningsTableView.dataSource = self

    }
    
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        
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
    
    @IBAction func addSeasoningsTapped(_ sender: Any) {
        let trimmed = addSeasoningsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed != "" {
            insertNewSeasoningsRow()
        }
        
    }
    
    func insertNewSeasoningsRow() {
        
        seasonings.append(addSeasoningsTextField.text!)
        
        //let rowNum = max(0, seasonings.count - 1)
        let indexPath = IndexPath(row: seasonings.count - 1, section: 0)
    
        seasoningsTableView.insertRows(at: [indexPath], with: .automatic)
        
        addSeasoningsTextField.text = ""
        view.endEditing(true)
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        //Save text entered into dishNameTextField ingredientsTextView, seasoningsTextView and instructionsTextView to Firebase
        
        //Create the recipe
        //let r = Recipe(recipeId: UUID().uuidString, dishName: dishNameTextField.text ?? "", ingredients: (ingredientsTextView.text as! Array), seasonings: seasoningsTextView.text, instructions: instructionsTextView.text, url: "")
    }
    
    func showImagePickerController(mode: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = mode
        imagePicker.delegate = self
        
        //Present the image picker
        present(imagePicker, animated: true)
    }
    
    
    

}

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

extension AddRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
            
        case ingredientsTableView:
            return ingredients.count
            
        case seasoningsTableView:
            return seasonings.count
            
        case instructionsTableView:
            return instructions.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case ingredientsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath)
            return cell
            
        case seasoningsTableView:
            let seasoningsEntry = seasonings[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeasoningsCell", for: indexPath) as! EntryCell
            cell.seasoningsLabel.text = seasoningsEntry
            return cell
    
        case instructionsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionsCell", for: indexPath)
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    
    
}
