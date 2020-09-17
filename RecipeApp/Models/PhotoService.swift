//
//  PhotoService.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/4/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class PhotoService {
    //This class is to handle all networking code to Firebase Storage
    
    func savePhoto(image:UIImage, recipeId: String) {
        
        //Call the photo service to store the photo
        PhotoService.savePhotoToFirebase(image: image, recipeId: recipeId)
    }
    
    static func savePhotoToFirebase(image: UIImage, recipeId:String) {
        
        //Get the data representation of the UIImage
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else {
            return
        }
        
        //Create a unique filename using the UUID class
        let filename = UUID().uuidString
        
        //Create a firebase storage reference
        let ref = Storage.storage().reference().child("images/\(filename).jpg")
        
        //Upload the data
        ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            //Check if the upload was successfull
            if error == nil {
                
                //Upon successful upload, create a metadata entry in the database
                self.createDatabaseEntry(ref: ref, recipeId: recipeId)

            } // End if
        } // End ref
    } // End func savePhoto
    
    private static func createDatabaseEntry(ref: StorageReference, recipeId:String) {
        
        //Download url
        ref.downloadURL { (url, error) in
            
            if error == nil {
                
                let photoId = ref.fullPath
                
                //Get a reference to the database
                let db = Firestore.firestore()
                
                //Get recipeId
                //let thisRecipe = db.collection("recipes").document() //This actually creates a new documentId. I want the recipeId already created
                //let recipeId = thisRecipe.documentID
                
                //Trying a second approach
                //Get a reference to the Recipe View Controller
                //let recipeVC = RecipeViewController()
                //let currentRecipe = recipeVC.recipe?.recipeId
                //let recipeId = recipeVC.recipe?.recipeId // This is nil
                
                //print(recipeId! as String) // This does not work. This is nil
            
                //Create a dictionary of the photo metadata
                let metadata = ["photoId":photoId, "recipeId":recipeId, "url":url!.absoluteString]
                print(recipeId)
                
                //Save the metadata to the Firestore database
                
                db.collection("photos").addDocument(data: metadata as [String : Any]) { (error) in
                    
                    if error == nil {
                        //Successfully created database entries
                                                
                    } // End if error
                } // End db.collection
            } // End if error
        } // End ref.downloadURL
    } // End createDatabaseEntry
    
    

} //End class
