//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 8/28/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase


class RecipeViewController: UIViewController {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var seasoningsTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    var recipe:Recipe?
    var recipesModel:RecipesModel?
    var photo:Photo?
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up UI
        ingredientsTextView.layer.cornerRadius = 5
        seasoningsTextView.layer.cornerRadius = 5
        instructionsTextView.layer.cornerRadius = 5
        

        if recipe != nil {
            
            title = "Recipe"
            
            //Populate fields
            dishNameLabel.text = recipe?.dishName
            
            //Loop through each ingredient in ingredients array, and display all items
            let ingredientsArray = recipe?.ingredients
            for i in 0...(ingredientsArray!.count - 1) {
                ingredientsTextView.text += "\(i+1). " + ingredientsArray![i] + "\n"
                
            }
            
            //Loop through each seasoning in seasonings array, and display all items
            let seasoningsArray = recipe?.seasonings
            for i in 0...(seasoningsArray!.count - 1) {
                seasoningsTextView.text += "\(i+1). " + seasoningsArray![i] + "\n"
                
            }
            
            //Loop through each instruction in instructions array, and display all items
            let instructionsArray = recipe?.instructions
            for i in 0...(instructionsArray!.count - 1) {
                instructionsTextView.text += "\(i+1). " + instructionsArray![i] + "\n"
                
            }
            
            
        } // End if recipe
    } // End ViewDidLoad
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Display Dish Photo
        //Call the PhotoService to retrieve the photos
        if recipe?.recipeId != nil { //recipeId is not nil
        
            PhotoService.retrievePhotos { [self] (retrievedPhotos) in
                
                self.photos = retrievedPhotos
                let thisRecipeId = recipe?.recipeId
                
                for i in 0...(retrievedPhotos.count - 1) {
                    
                    if retrievedPhotos[i].recipeId == thisRecipeId {
                        
                        let photoIndex = i
                        
                        //Setting the display photo
                        self.photo = photos[photoIndex]
                        
                        break
                        
                    } //End if retrievedPhotos
                } // End for i in 0
                
                if self.photo != nil {
                    PhotoService.displayPhoto(photo: photo!) { (data) in
                        
                        //Set the image view
                        let image = UIImage(data: data)
                        
                        DispatchQueue.main.async {
                            
                            dishImageView.image = image
                        } // End DispatchQueue
                    } //End PhotoService.displayPhoto
                } // End if self.photo
            } // End PhotoService.retrievePhotos
        } // End if recipe?.recipeId
    } //End viewWillAppear
    
    
    
    

    @IBAction func cameraTapped(_ sender: Any) {
        
        //Create the action sheet
        let actionSheet = UIAlertController(title: "Add a Photo", message: "Select a source:", preferredStyle: .actionSheet)
        
        //Only add the Camera button if it is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //Create and add the Camera button
            let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
                
                //Display the UIImagePickerController set to camera mode
                self.showImagePickerController(mode: .camera)
                
            }
            
            //Add Camera button to action sheet
            actionSheet.addAction(cameraButton)
            
        } // End if
            
            
        //Only add the Photo Library button if it is available
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //Create and add the Photo Library button
            let libraryButton = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                
                //Display the UIImagePickerController set to library mode
                self.showImagePickerController(mode: .photoLibrary)
                
            }
            
            //Add Photo Library button to action sheet
            actionSheet.addAction(libraryButton)
        } // End if
        
        //Create and add the Cancel button to action sheet
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelButton)
        
        //Display the action sheet
        present(actionSheet, animated: true)

    } // End cameraTapped
    
    func showImagePickerController(mode: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = mode
        imagePicker.delegate = self
        
        //Present the image picker
        present(imagePicker, animated: true)
    } // End showImagePickerController
    

} // End class


// MARK: - Image picker protocol functions
extension RecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Get a reference to the selected photo
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //Check that the selected image isn't nil
        if let selectedImage = selectedImage {
            
            //Get a reference to Photoservice
            let photoService = PhotoService()
            
            //Get selected recipe Id
            let selectedRecipeId = recipe!.recipeId as String
            
            //Upload it
            photoService.savePhoto(image: selectedImage, recipeId: selectedRecipeId)
                    
            
        } // End if
        
        //Dismiss the image picker
        dismiss(animated: true, completion: nil)
        
    } // End imagePicker Controller
    
}
