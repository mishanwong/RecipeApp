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
    
    static func savePhotoToFirebase(image: UIImage) {
        
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
                self.createDatabaseEntry(ref: ref)

            } // End if
        } // End ref
    } // End func savePhoto
    
    private static func createDatabaseEntry(ref: StorageReference) {
        
        //Download url
        ref.downloadURL { (url, error) in
            
            if error == nil {
                
                let photoId = ref.fullPath
                
                //TODO: Get dishName
                let dishName = "Dish Name Placeholder"
                
                //TODO: Get recipeId
                let recipeId = "Recipe ID Placeholder"
                
                
                //Create a dictionary of the photo metadata
                let metadata = ["photoId":photoId, "recipeId":recipeId, "dishName":dishName, "url":url!.absoluteString]
                
                //Save the metadata to the Firestore database
                let db = Firestore.firestore()
                
                db.collection("photos").addDocument(data: metadata) { (error) in
                    
                    if error == nil {
                        //Successfully created database entries
                        
                        
                    }
                }
                
                
            }
            
            
        }
            
    }
    
    
    
} //End class
