//
//  PhotoService.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/4/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class PhotoService {
    //This class is to handle all networking code to Firebase Storage
    
    static func retrievePhotos(completion: @escaping ([Photo]) -> Void) {
        
        //Get a database reference
        let db = Firestore.firestore()
          
        //Retry here
        db.collection("photos").getDocuments { (snapshot, error) in
                        
            if error == nil && snapshot != nil {
                let documents = snapshot?.documents
                
                if let documents = documents {
                    var photoArray = [Photo]()
                    
                    for doc in documents {
                        let p = Photo(snapshot: doc)
                        
                        if p != nil {
                            photoArray.insert(p!, at: 0)
                        }
                    }
                    
                    completion(photoArray)
                    
                } // End if let
            } // End if error
        } // End db.collection
    }//End static func retrievePhotos
        
        
    
    //Display Photo
    static func displayPhoto(photo:Photo, completion: @escaping (Data) -> Void) {
        
        //Check that there is a valid download url
        if photo.urlString == nil {
            return
        } // End if photo
    
        //Download the image
        let url = URL(string: photo.urlString!)
        
        //Check that url object was created
        if url == nil {
            return
        }
        
        //Use url session to download the image asynchronously
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            //Check for erros and data
            if error == nil && data != nil {
                
                //Set the image view
//                let image = UIImage(data: data!)
//
//                DispatchQueue.main.async {
//
//                    dishImageView.image = image
//                }
                completion(data!)
            } // End if error
        } // end let dataTask
        
        dataTask.resume()
       
    } // End func displayPhoto
    
    
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
        //let filename = UUID().uuidString
        let filename = recipeId
        
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
            
                //Create a dictionary of the photo metadata
                let metadata = ["photoId":photoId, "recipeId":recipeId, "urlString":url!.absoluteString]
                                
        
                //Save the metadata to the Firestore database
                db.collection("photos").document(recipeId).setData(metadata)
                
            } // End if error
        } // End ref.downloadURL
    } // End createDatabaseEntry
} //End class
