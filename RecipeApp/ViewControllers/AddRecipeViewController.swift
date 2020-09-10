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
    @IBOutlet weak var tableView: UITableView!
    
    var recipe:Recipe?
    
    var ingredients = [String]()
    var seasonings = [String]()
    var instructions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Recipe"
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    
    
    @IBAction func addDishNameButtonTapped(_ sender: Any) {
        
        //Tapping this button will create a new document in the recipes collection in Firestore
        
        let db = Firestore.firestore()
        
        let newRecipe = db.collection("recipes").document()
        
        newRecipe.setData(["recipeId":newRecipe.documentID, "dishName":dishNameTextField.text!])
        
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
    
   
    
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
    @IBAction func saveTapped(_ sender: Any) {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //This works
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var str:String = ""
        
        if section == 0 {
            str = "Ingredients"
        }
        if section == 1 {
            str = "Seasonings"
        }
        if section == 2 {
            str = "Instructions"
        }
        return str
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var num:Int = 0
        
        if section == 0 {
            if ingredients.count == 0 {
                num = 3
            }
            else {
                num = ingredients.count
            }
        }
        
        if section == 1 {
            if seasonings.count == 0 {
                num = 3
            }
            else {
                num = seasonings.count
            }
            
        }
        
        if section == 2 {
            if instructions.count == 0 {
                num = 3
            }
            else {
                num = instructions.count
            }
        }
        return num
    } // End func
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryCell
        
        //Configure the cell
        //cell.entryTextLabel.text = ingredients[indexPath.row]
        return cell
            
    } // End func
     
} // End extension
